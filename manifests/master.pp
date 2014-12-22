# == Class: puppet::master
#
# Configures a host to run Apache/Passenger/Puppet and serve up manifests.
#
class puppet::master (
  $autosign                     = $puppet::master::env::autosign,
  $dns_alt_names                = $puppet::master::env::dns_alt_names,
  $env_owner                    = $puppet::master::env::env_owner,
  $environmentpath              = $puppet::master::env::environmentpath,
  $eyaml_keys                   = $puppet::master::env::eyaml_keys,
  $future_parser                = $puppet::master::env::future_parser,
  $hiera_backends               = $puppet::master::env::hiera_backends,
  $hiera_eyaml_version          = $puppet::master::env::hiera_eyaml_version,
  $hiera_hierarchy              = $puppet::master::env::hiera_hierarchy,
  $hieradata_path               = $puppet::master::env::hieradata_path,
  $manage_ssl                   = $puppet::master::env::manage_ssl,
  $module_path                  = $puppet::master::env::module_path,
  $passenger_max_pool_size      = $puppet::master::env::passenger_max_pool_size,
  $passenger_max_requests       = $puppet::master::env::passenger_max_requests,
  $passenger_pool_idle_time     = $puppet::master::env::passenger_pool_idle_time,
  $passenger_stat_throttle_rate = $puppet::master::env::passenger_stat_throttle_rate,
  $pre_module_path              = $puppet::master::env::pre_module_path,
  $puppet_ca_cert               = $puppet::master::env::puppet_ca_cert,
  $puppet_ca_key                = $puppet::master::env::puppet_ca_key,
  $puppet_ca_pass               = $puppet::master::env::puppet_ca_pass,
  $puppet_fqdn                  = $puppet::master::env::puppet_fqdn,
  $puppet_version               = $puppet::master::env::puppet_version,
  $r10k_version                 = $puppet::master::env::r10k_version,
) inherits puppet::master::env {

  validate_bool($manage_ssl)
  validate_string($module_path, $pre_module_path)

  $pre_module_path_real = $pre_module_path ? {
    undef    => '',
    /\w+\:$/ => $pre_module_path,
    default  => "${pre_module_path}:"
  }

  $extra_module_path = $module_path ? {
    undef   => "${pre_module_path_real}${::settings::confdir}/site:/usr/share/puppet/modules",
    default => "${pre_module_path_real}${module_path}",
  }

  class { 'puppet::master::install':
    hiera_eyaml_version => $hiera_eyaml_version,
    puppet_version      => $puppet_version,
    r10k_version        => $r10k_version,
  }

  class { 'puppet::master::config':
    autosign          => $autosign,
    dns_alt_names     => $dns_alt_names,
    environmentpath   => $environmentpath,
    extra_module_path => $extra_module_path,
    future_parser     => $future_parser,
    puppet_fqdn       => $puppet_fqdn,
    notify            => Class['puppet::master::passenger'],
    require           => Class['puppet::master::install'];
  }

  class { 'puppet::master::hiera':
    env_owner       => $env_owner,
    eyaml_keys      => $eyaml_keys,
    hieradata_path  => $hieradata_path,
    hiera_backends  => $hiera_backends,
    hiera_hierarchy => $hiera_hierarchy,
    notify          => Class['puppet::master::passenger'],
    require         => Class['puppet::master::config'];
  }

  if $manage_ssl {
    class {'puppet::master::ssl':
      puppet_ca_cert => $puppet_ca_cert,
      puppet_ca_key  => $puppet_ca_key,
      puppet_ca_pass => $puppet_ca_pass,
      puppet_fqdn    => $puppet_fqdn,
      notify         => Class['puppet::master::passenger'],
      subscribe      => Class['puppet::master::config'],
      require        => Class['puppet::master::install'];
    }
  }

  class { 'puppet::master::passenger':
    passenger_max_pool_size      => $passenger_max_pool_size,
    passenger_max_requests       => $passenger_max_requests,
    passenger_pool_idle_time     => $passenger_pool_idle_time,
    passenger_stat_throttle_rate => $passenger_stat_throttle_rate,
    puppet_fqdn                  => $puppet_fqdn,
    require => Class['puppet::master::install'];
  }
}
