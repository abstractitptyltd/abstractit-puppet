class puppet::master (
  $modules          = false,
  $hiera_repo       = undef,
  $r10k_sources     = undef,
  $pre_module_path  = '',
  $module_path      = '',
  $puppet_version   = 'installed',
  $puppetdb_version = 'installed',
  $r10k_version     = 'installed',
  $hiera_eyaml_version          = 'installed',
  $host             = $puppet::master::params::host,
  $hieradata_path   = $puppet::master::params::hieradata_path,
  $env_owner        = $puppet::master::params::env_owner,
  $eyaml            = $puppet::master::params::eyaml,
  $hiera_yaml_path  = $puppet::master::params::hiera_eyaml_path,
  $hiera_eyaml_path = $puppet::master::params::hiera_eyaml_path,
  $future_parser    = $puppet::master::params::future_parser,
  $environmentpath  = $puppet::master::params::environmentpath,
  $autosign         = $puppet::master::params::autosign,
  $puppetdb         = $puppet::master::params::puppetdb,
  $puppetdb_ssl_listen_address  = $puppet::master::params::puppetdb_ssl_listen_address,
  $passenger_max_pool_size      = $puppet::master::params::passenger_max_pool_size,
  $passenger_pool_idle_time     = $puppet::master::params::passenger_pool_idle_time,
  $passenger_stat_throttle_rate = $puppet::master::params::passenger_stat_throttle_rate,
  $passenger_max_requests       = $puppet::master::params::passenger_max_requests,
  $reports          = $puppet::master::params::reports,
  $unresponsive     = $puppet::master::params::unresponsive,
  $puppetboard_revision         = $puppet::master::params::puppetboard_revision,) inherits puppet::master::params {
  $pre_module_path_real = $pre_module_path ? {
    ''       => '',
    /\w+\:$/ => $pre_module_path,
    default  => "${pre_module_path}:"
  }
  $real_module_path     = $module_path ? {
    ''      => "${pre_module_path_real}${::settings::confdir}/site:/usr/share/puppet/modules",
    default => "${pre_module_path_real}${module_path}",
  }

  class { 'puppet::master::install':
    puppet_version      => $puppet_version,
    puppetdb_version    => $puppetdb_version,
    r10k_version        => $r10k_version,
    hiera_eyaml_version => $hiera_eyaml_version
  } ->
  class { 'puppet::master::config':
    future_parser    => $future_parser,
    environmentpath  => $environmentpath,
    real_module_path => $real_module_path,
    autosign         => $autosign
  } ->
  class { 'puppet::master::hiera':
    hiera_repo       => $hiera_repo,
    hieradata_path   => $hieradata_path,
    env_owner        => $env_owner,
    eyaml            => $eyaml,
    hiera_yaml_path  => $hiera_yaml_path,
    hiera_eyaml_path => $hiera_eyaml_path
  } ~>
  class { 'puppet::master::passenger':
    host => $host,
    passenger_max_pool_size      => $passenger_max_pool_size,
    passenger_pool_idle_time     => $passenger_pool_idle_time,
    passenger_stat_throttle_rate => $passenger_stat_throttle_rate,
    passenger_max_requests       => $passenger_max_requests
  }

  if ($modules == true) {
    class { 'puppet::master::modules':
      env_owner    => $env_owner,
      r10k_sources => $r10k_sources,
      hiera_repo   => $hiera_repo
    }
  }

  if ($puppetdb == true) {
    class { 'puppet::master::puppetdb':
      puppetdb_version => $puppetdb_version,
      node_ttl         => $node_ttl,
      node_purge_ttl   => $node_purge_ttl,
      report_ttl       => $report_ttl,
      host             => $host,
      reports          => $reports,
      puppetdb_ssl_listen_address => $puppetdb_ssl_listen_address
    }
  }
}
