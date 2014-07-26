# # Class puppet::master::params
# setting for the puppet master classes

class puppet::master::params (
  $autosign                     = false,
  $devel_repo                   = $puppet::params::devel_repo,
  $env_owner                    = 'puppet',
  $environment                  = $puppet::params::environment,
  $environmentpath              = '/etc/puppet/environments',
  $future_parser                = false,
  $hiera_backends   = {
    'yaml' => {
      'datadir' => '/etc/puppet/hiera/%{environment}',
    }
  },
  $hiera_hierarchy  = [
    'node/%{::clientcert}',
    'env/%{::environment}',
    'global'],
  $hieradata_path               = '/etc/puppet/hiera',
  $node_purge_ttl               = '0s',
  $node_ttl                     = '0s',
  $passenger_max_pool_size      = '12',
  $passenger_max_requests       = '0',
  $passenger_pool_idle_time     = '1500',
  $passenger_stat_throttle_rate = '120',
  $puppet_fqdn                  = $::fqdn,
  $puppet_server                = $puppet::params::puppet_server,
  $puppetdb                     = true,
  $puppetdb_listen_address      = '127.0.0.1',
  $puppetdb_server              = "puppet.${::domain}",
  $puppetdb_ssl_listen_address  = '127.0.0.1',
  $r10k_env_basedir             = '/etc/puppet/r10kenv',
  $r10k_minutes     = [
    0,
    15,
    30,
    45],
  $r10k_update                  = true,
  $report_ttl                   = '14d',
  $reports                      = true,
  $unresponsive                 = '2',
) inherits puppet::params {
}
