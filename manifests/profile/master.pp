class puppet::profile::master (
  $hiera_eyaml_version          = 'installed',
  $puppet_version               = 'installed',
  $r10k_version                 = 'installed',
  $environmentpath              = '/etc/puppet/environments',
  $module_path                  = '',
  $pre_module_path              = '',
  $future_parser                = false,
  $autosign                     = false,
  $env_owner                    = 'puppet',
  $eyaml_keys                   = false,
  $hiera_backends               = {
    'yaml' => {
      'datadir' => '/etc/puppet/hiera/%{environment}',
    }
  },
  $hieradata_path               = '/etc/puppet/hiera',
  $hiera_hierarchy,
  $passenger_max_pool_size      = '12',
  $passenger_max_requests       = '0',
  $passenger_pool_idle_time     = '1500',
  $passenger_stat_throttle_rate = '120',
  $puppet_fqdn                  = $::fqdn,
  $puppet_server                = 'puppet',
  $modules                      = true,
  $extra_env_repos              = undef,
  $hiera_repo,
  $puppet_env_repo              = undef,
  $r10k_env_basedir             = '/etc/puppet/r10kenv',
  $r10k_minutes                 = [
    0,
    15,
    30,
    45],
  $r10k_purgedirs               = true,
  $r10k_update                  = true,
  $puppetdb                     = true,
  $puppetdb_version             = 'installed',
  $node_purge_ttl               = '0s',
  $node_ttl                     = '0s',
  $puppetdb_listen_address      = '127.0.0.1',
  $puppetdb_server              = $::fqdn,
  $puppetdb_ssl_listen_address  = '127.0.0.1',
  $report_ttl                   = '14d',
  $reports                      = true,
  $puppetdb_use_ssl             = true,
) inherits puppet::profile::agent {
  class { 'puppet::master':
    hiera_eyaml_version          => $hiera_eyaml_version,
    puppet_version               => $puppet_version,
    r10k_version                 => $r10k_version,
    environmentpath              => $environmentpath,
    module_path                  => $module_path,
    pre_module_path              => $pre_module_path,
    future_parser                => $future_parser,
    autosign                     => $autosign,
    env_owner                    => $env_owner,
    eyaml_keys                   => $eyaml_keys,
    hiera_backends               => $hiera_backends,
    hieradata_path               => $hieradata_path,
    hiera_hierarchy              => $hiera_hierarchy,
    passenger_max_pool_size      => $passenger_max_pool_size,
    passenger_max_requests       => $passenger_max_requests,
    passenger_pool_idle_time     => $passenger_pool_idle_time,
    passenger_stat_throttle_rate => $passenger_stat_throttle_rate,
    puppet_fqdn                  => $puppet_fqdn,
    puppet_server                => $puppet_server,
  }

  if ($modules == true) {
    class { 'puppet::master::modules':
      env_owner        => $env_owner,
      extra_env_repos  => $extra_env_repos,
      hiera_repo       => $hiera_repo,
      puppet_env_repo  => $puppet_env_repo,
      r10k_env_basedir => $r10k_env_basedir,
      r10k_minutes     => $r10k_minutes,
      r10k_purgedirs   => $r10k_purgedirs,
      r10k_update      => $r10k_update,
    }
  }

  if ($puppetdb == true) {
    class { 'puppet::master::puppetdb':
      puppetdb_version            => $puppetdb_version,
      node_purge_ttl              => $node_purge_ttl,
      node_ttl                    => $node_ttl,
      puppetdb_listen_address     => $puppetdb_listen_address,
      puppetdb_server             => $puppetdb_server,
      puppetdb_ssl_listen_address => $puppetdb_ssl_listen_address,
      report_ttl                  => $report_ttl,
      reports                     => $reports,
      use_ssl                     => $puppetdb_use_ssl,
    }
  }

}
