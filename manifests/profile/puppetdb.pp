# Class puppet::profile::puppetdb
# 
# The puppet::master::puppetdb class is responsible for configuring PuppetDB
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
# @param puppetdb_server [String] Default: puppet.${::domain}
#   The dns name or ip of the puppetdb server.
# @param puppetdb_ssl_listen_address [String] Default: 127.0.0.1
#   The address that the web server should bind to for HTTPS requests. Set to '0.0.0.0' to listen on all addresses.
# @param report_ttl [String] Default: '14d'
#   The length of time reports should be stored before being deleted. (defaults to 14 days).
# @param reports [Boolean] Default: true
#   A toggle to alter the behavior of reports and puppetdb.
#   If true, the module will properly set the 'reports' field in the puppet.conf file to enable the puppetdb report processor.
# @param use_ssl [Boolean] Defaults: true
#   A toggle to enable or disable ssl on puppetdb connections.
# @param listen_port [String] Defaults: '8080'
#   Non ssl Port to use for puppetdb
# @param ssl_listen_port [String] Defaults: '8081'
#   Ssl Port to use for puppetdb
# @puppet_server_type [String] Defaults: 'passenger'
#   Type of puppet server set to puppetserver if using the new puppetserver

class puppet::profile::puppetdb (
  $puppetdb_version            = 'installed',
  $node_purge_ttl              = '0s',
  $node_ttl                    = '0s',
  $puppetdb_listen_address     = '127.0.0.1',
  $puppetdb_server             = "puppet.${::domain}",
  $puppetdb_ssl_listen_address = '0.0.0.0',
  $report_ttl                  = '14d',
  $reports                     = true,
  $use_ssl                     = true,
  $listen_port                 = '8080',
  $ssl_listen_port             = '8081',
  $puppet_server_type          = 'passenger',
) {
  include ::puppet::defaults

  case $use_ssl {
    default : {
      $puppetdb_port = $ssl_listen_port
      $disable_ssl = false
    }
    false   : {
      $puppetdb_port = $listen_port
      $disable_ssl = true
    }
  }
  case $puppet_server_type {
    default: {
      $puppet_service_name = 'httpd'
    }
    'puppetserver': {
      $puppet_service_name = 'puppetserver'
    }
  }

  $terminus_package = $::puppet::defaults::terminus_package
  $confdir          = $::puppet::defaults::puppetdb_confdir
  $ssl_dir          = $::puppet::defaults::puppetdb_ssl_dir
  $test_url         = $::puppet::defaults::puppetdb_test_url
  $puppet_confdir   = $::puppet::defaults::confdir

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
    disable_ssl        => $disable_ssl,
    listen_address     => $puppetdb_listen_address,
    ssl_listen_address => $puppetdb_ssl_listen_address,
    node_ttl           => $node_ttl,
    node_purge_ttl     => $node_purge_ttl,
    report_ttl         => $report_ttl,
    confdir            => $confdir,
    ssl_dir            => $ssl_dir,
    # require            => Class['::puppet::master'],
  }

  # setup puppetdb config for puppet master
  class { '::puppetdb::master::config':
    manage_config           => false,
    test_url                => $test_url,
    puppetdb_port           => $puppetdb_port,
    puppetdb_server         => $puppetdb_server,
    puppet_service_name     => $puppet_service_name,
    enable_reports          => $reports,
    manage_report_processor => $reports,
    restart_puppet          => true,
    require                 => Class['::puppetdb'],
  }

  class { '::puppetdb::master::puppetdb_conf':
    port            => $ssl_listen_port,
    puppet_confdir  => $puppet_confdir,
    legacy_terminus => $terminus_package,
  }

}
