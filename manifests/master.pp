class puppet::master (
  $autosign                     = $puppet::master::params::autosign,
  $env_owner                    = $puppet::master::params::env_owner,
  $environmentpath              = $puppet::master::params::environmentpath,
  $eyaml_keys                   = false,
  $future_parser                = $puppet::master::params::future_parser,
  $hiera_backends               = $puppet::master::params::hiera_backends,
  $hiera_eyaml_version          = 'installed',
  $hiera_hierarchy              = $puppet::master::params::hiera_hierarchy,
  $hieradata_path               = $puppet::master::params::hieradata_path,
  $module_path                  = '',
  $passenger_max_pool_size      = $puppet::master::params::passenger_max_pool_size,
  $passenger_max_requests       = $puppet::master::params::passenger_max_requests,
  $passenger_pool_idle_time     = $puppet::master::params::passenger_pool_idle_time,
  $passenger_stat_throttle_rate = $puppet::master::params::passenger_stat_throttle_rate,
  $pre_module_path              = '',
  $puppet_fqdn                  = $puppet::master::params::puppet_fqdn,
  $puppet_server                = $puppet::master::params::puppet_server,
  $puppet_version               = 'installed',
  $r10k_version                 = 'installed',
) inherits puppet::master::params {

  #input validation
  validate_absolute_path(
    $environmentpath,
    $hieradata_path,
  )
  validate_array(
    $hiera_hierarchy,
  )

  validate_bool(
    $autosign,
    $eyaml_keys,
    $future_parser,
  )

  validate_hash(
    $hiera_backends
  )

  validate_string(
    $env_owner,
    $hiera_eyaml_version,
    $passenger_max_pool_size,
    $passenger_max_requests,
    $passenger_pool_idle_time,
    $passenger_stat_throttle_rate,
    $puppet_fqdn,
    $puppet_server,
    $puppet_version,
    $r10k_version,
  )

  if $pre_module_path{
    validate_string($pre_module_path)
  }
  if $module_path{
    validate_string($module_path)
  }

  $pre_module_path_real = $pre_module_path ? {
    ''       => '',
    /\w+\:$/ => $pre_module_path,
    default  => "${pre_module_path}:"
  }
  $extra_module_path    = $module_path ? {
    ''      => "${pre_module_path_real}${::settings::confdir}/site:/usr/share/puppet/modules",
    default => "${pre_module_path_real}${module_path}",
  }

  class { 'puppet::master::install':
    puppet_version      => $puppet_version,
    r10k_version        => $r10k_version,
    hiera_eyaml_version => $hiera_eyaml_version
  } ->
  class { 'puppet::master::config':
    future_parser     => $future_parser,
    environmentpath   => $environmentpath,
    extra_module_path => $extra_module_path,
    autosign          => $autosign
  } ->
  class { 'puppet::master::hiera':
    hiera_backends => $hiera_backends,
    hierarchy      => $hiera_hierarchy,
    hieradata_path => $hieradata_path,
    env_owner      => $env_owner,
    eyaml_keys     => $eyaml_keys,
  } ~>
  class { 'puppet::master::passenger':
    puppet_fqdn                  => $puppet_fqdn,
    passenger_max_pool_size      => $passenger_max_pool_size,
    passenger_pool_idle_time     => $passenger_pool_idle_time,
    passenger_stat_throttle_rate => $passenger_stat_throttle_rate,
    passenger_max_requests       => $passenger_max_requests
  }

}
