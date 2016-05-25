# Class puppet::profile::puppetdb
#
# The puppet::master::puppetdb class is responsible for configuring PuppetDB
# It will only setup PuppetDB, if you want to setup PuppetDB on the node your puppet master run on
# please use the puppet::profile::master class
# This and the puppet::profile::master class are mutually exclusive and will not work on the same node.
#
# @puppet::profile::puppetdb when declaring the puppet::profile::puppetdb class
#   include puppet::profile::puppetdb
#
# @param puppetdb_version [String] Default: 'installed'
#   The version of puppetdb to install.
# @param node_purge_ttl [String] Default: 0s
#   The length of time a node can be deactivated before it's deleted from the database. (a value of '0' disables purging).
# @param node_ttl [String] Default: '0s'
#   The length of time a node can go without receiving any new data before it's automatically deactivated. (defaults to '0', which disables auto-deactivation).
# @param puppetdb_listen_address [String] Default: 127.0.0.1
#   The address that the web server should bind to for HTTP requests. Set to '0.0.0.0' to listen on all addresses.
# @param puppetdb_ssl_listen_address [String] Default: 127.0.0.1
#   The address that the web server should bind to for HTTPS requests. Set to '0.0.0.0' to listen on all addresses.
# @param report_ttl [String] Default: '14d'
#   The length of time reports should be stored before being deleted. (defaults to 14 days).
# @param use_ssl [Boolean] Defaults: true
#   A toggle to enable or disable ssl on puppetdb connections.
# @param listen_port [String] Defaults: '8080'
#   Non ssl Port to use for puppetdb
# @param ssl_listen_port [String] Defaults: '8081'
#   Ssl Port to use for puppetdb

class puppet::profile::puppetdb (
  $puppetdb_version            = 'installed',
  $node_purge_ttl              = '0s',
  $node_ttl                    = '0s',
  $puppetdb_listen_address     = '127.0.0.1',
  $puppetdb_server             = undef,
  $puppetdb_ssl_listen_address = '0.0.0.0',
  $report_ttl                  = '14d',
  $reports                     = undef,
  $use_ssl                     = true,
  $listen_port                 = '8080',
  $ssl_listen_port             = '8081',
  $puppet_server_type          = undef,
) {
  # input validation
  validate_bool(
    $use_ssl
  )
  validate_string(
    $puppetdb_version,
    $node_purge_ttl,
    $node_ttl,
    $puppetdb_listen_address,
    $puppetdb_ssl_listen_address,
    $report_ttl,
  )
  validate_integer(
    [
      $listen_port,
      $ssl_listen_port,
    ]
  )

  # add deprecation warnings
  if $puppetdb_server != undef {
    notify { 'Deprecation notice: puppet::profile::puppetdb::puppetdb_server is deprecated, use puppet::profile::master to setup PuppetDB on your puppetmaster': }
  }
  if $reports != undef {
    notify { 'Deprecation notice: puppet::profile::puppetdb::reports is deprecated, use puppet::profile::master to setup PuppetDB on your puppetmaster': }
  }
  if $puppet_server_type != undef {
    notify { 'Deprecation notice: puppet::profile::puppetdb::puppet_server_type is deprecated, use puppet::profile::master to setup PuppetDB on your puppetmaster': }
  }

  case $use_ssl {
    default : {
      $puppetdb_port = $ssl_listen_port
      $disable_ssl = false
      $ssl_deploy_certs = true
    }
    false   : {
      $puppetdb_port = $listen_port
      $disable_ssl = true
      $ssl_deploy_certs = false
    }
  }

  # add pg_trgm to the puppetdb database
  # remove this once the puppetdb module supports it
  # need postgresql::server::contrib class to make pg_trgm work
  # class { '::postgresql::server::contrib':
  # }
  # postgresql::server::extension{ 'pg_trgm':
  #   database => 'puppetdb',
  # }

  # version is now managed with the puppetdb::globals class
  class { '::puppetdb::globals':
    version   => $puppetdb_version,
  }

  # setup puppetdb
  class { '::puppetdb':
    listen_port        => $listen_port,
    ssl_listen_port    => $ssl_listen_port,
    ssl_deploy_certs   => $ssl_deploy_certs,
    disable_ssl        => $disable_ssl,
    listen_address     => $puppetdb_listen_address,
    ssl_listen_address => $puppetdb_ssl_listen_address,
    node_ttl           => $node_ttl,
    node_purge_ttl     => $node_purge_ttl,
    report_ttl         => $report_ttl,
  }

}
