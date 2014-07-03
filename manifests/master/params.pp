# # Class puppet::master::params
# setting for the puppet master classes

class puppet::master::params (
  $hieradata_path   = '/etc/puppet/hiera',
  $hiera_backends   = {
    'yaml' => {
      'datadir' => '/etc/puppet/hiera/%{environment}',
    }
  }
  ,
  $hiera_hierarchy  = [
    'node/%{::clientcert}',
    'env/%{::environment}',
    'global'],
  $env_owner        = 'puppet',
  $future_parser    = false,
  $environmentpath  = '/etc/puppet/environments',
  $puppetdb_server  = "puppet.${::domain}",
  $puppet_fqdn      = $::fqdn,
  $puppet_server    = $puppet::params::puppet_server,
  $environment      = $puppet::params::environment,
  $devel_repo       = $puppet::params::devel_repo,
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
  $puppetdb_listen_address      = '127.0.0.1',
  $puppetdb_ssl_listen_address  = '127.0.0.1',
  $passenger_max_pool_size      = '12',
  $passenger_pool_idle_time     = '1500',
  $passenger_stat_throttle_rate = '120',
  $passenger_max_requests       = '0') inherits puppet::params {
}
