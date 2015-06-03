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

class puppet::profile::puppetdb (
  $puppetdb_version            = 'installed',
  $node_purge_ttl              = '0s',
  $node_ttl                    = '0s',
  $puppetdb_listen_address     = '127.0.0.1',
  $puppetdb_server             = "puppet.${::domain}",
  $puppetdb_ssl_listen_address = '127.0.0.1',
  $report_ttl                  = '14d',
  $reports                     = true,
  $use_ssl                     = true,
) {
  case $use_ssl {
    default : {
      $puppetdb_port = '8081'
      $disable_ssl = false
    }
    false   : {
      $puppetdb_port = '8080'
      $disable_ssl = true
    }
  }

  # add pg_trgm to the puppetdb database
  # remove this once the puppetdb module supports it
  postgresql::server::extension{ 'pg_trgm':
    database => 'puppetdb',
  }

  # setup puppetdb
  class { '::puppetdb':
    disable_ssl        => $disable_ssl,
    listen_address     => $puppetdb_listen_address,
    ssl_listen_address => $puppetdb_ssl_listen_address,
    node_ttl           => $node_ttl,
    node_purge_ttl     => $node_purge_ttl,
    report_ttl         => $report_ttl,
    puppetdb_version   => $puppetdb_version,
    require            => Class['::puppet::master'],
  }

  class { '::puppetdb::master::config':
    puppetdb_port           => $puppetdb_port,
    puppetdb_server         => $puppetdb_server,
    puppet_service_name     => 'httpd',
    enable_reports          => $reports,
    manage_report_processor => $reports,
    restart_puppet          => true,
    puppetdb_version        => $puppetdb_version,
    require                 => Class['::puppetdb'],
  }

  # cleanup old puppet reports
  cron { 'puppet clean reports':
    command => 'cd /var/lib/puppet/reports && find . -type f -name \*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f',
    user    => root,
    hour    => 21,
    minute  => 22,
    weekday => 0,
  }

}
