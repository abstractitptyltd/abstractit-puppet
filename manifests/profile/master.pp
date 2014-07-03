class puppet::profile::master (
  $hiera_repo,
  $hiera_hierarchy,
  $puppet_env_repo  = undef,
  $extra_env_repos  = undef,
  $modules          = true,
  $host             = "puppet.${::domain}",
  $puppet_server    = 'puppet',
  $puppet_fqdn      = $::fqdn,
  $puppetdb_use_ssl = true,
  $puppetdb_ssl_listen_address  = '127.0.0.1',
  $puppet_version   = 'installed',
  $puppetdb_version = 'installed',
  $r10k_version     = 'installed',
  $hiera_eyaml_version          = 'installed',
  $pre_module_path  = '',
  $module_path      = '',
  $eyaml_keys       = false,
  $hieradata_path   = '/etc/puppet/hiera',
  $hiera_backends   = {
    'yaml' => {
      'datadir' => '/etc/puppet/hiera/%{environment}',
    }
  }
  ,
  $env_owner        = 'puppet',
  $eyaml            = false,
  $hiera_eyaml_path = '/etc/puppet/hiera/%{environment}',
  $hiera_yaml_path  = '/etc/puppet/hiera/%{environment}',
  $future_parser    = false,
  $environmentpath  = '/etc/puppet/environments',
  $git_protocol     = 'ssh',
  $autosign         = false,
  $reports          = true,
  $node_ttl         = '0s',
  $node_purge_ttl   = '0s',
  $report_ttl       = '14d',
  $unresponsive     = '2',
  $r10k_env_basedir = '/etc/puppet/r10kenv',
  $r10k_update      = true,
  $r10k_minutes     = [
    0,
    15,
    30,
    45],
  $puppetdb         = true,
  $puppetboard      = true,
  $puppetboard_revision         = undef,
  $passenger_max_pool_size      = '12',
  $passenger_pool_idle_time     = '1500',
  $passenger_stat_throttle_rate = '120',
  $passenger_max_requests       = '0',) inherits puppet::profile::agent {
  class { 'puppet::master':
    puppet_version  => $puppet_version,
    r10k_version    => $r10k_version,
    hiera_eyaml_version          => $hiera_eyaml_version,
    host            => $host,
    hiera_hierarchy => $hiera_hierarchy,
    hiera_backends  => $hiera_backends,
    puppetdb_ssl_listen_address  => $puppetdb_ssl_listen_address,
    pre_module_path => $pre_module_path,
    module_path     => $module_path,
    hieradata_path  => $hieradata_path,
    env_owner       => $env_owner,
    future_parser   => $future_parser,
    environmentpath => $environmentpath,
    autosign        => $autosign,
    passenger_max_pool_size      => $passenger_max_pool_size,
    passenger_pool_idle_time     => $passenger_pool_idle_time,
    passenger_stat_throttle_rate => $passenger_stat_throttle_rate,
    passenger_max_requests       => $passenger_max_requests
  }

  if ($modules == true) {
    class { 'puppet::master::modules':
      hiera_repo       => $hiera_repo,
      puppet_env_repo  => $puppet_env_repo,
      env_owner        => $env_owner,
      extra_env_repos  => $extra_env_repos,
      r10k_env_basedir => $r10k_env_basedir,
      r10k_update      => $r10k_update,
      r10k_minutes     => $r10k_minutes
    }
  }

  if ($puppetdb == true) {
    class { 'puppet::master::puppetdb':
      puppetdb_version => $puppetdb_version,
      use_ssl          => $puppetdb_use_ssl,
      node_ttl         => $node_ttl,
      node_purge_ttl   => $node_purge_ttl,
      report_ttl       => $report_ttl,
      host             => $host,
      reports          => $reports,
      puppetdb_listen_address     => $puppetdb_ssl_listen_address,
      puppetdb_ssl_listen_address => $puppetdb_ssl_listen_address
    }
  }

}
