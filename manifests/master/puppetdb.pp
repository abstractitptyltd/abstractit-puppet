# # class puppet::master::puppetdb

class puppet::master::puppetdb (
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
  #input validation
  validate_bool(
    $reports,
    $use_ssl,
  )

  validate_string(
    $node_purge_ttl,
    $node_ttl,
    $puppetdb_listen_address,
    $puppetdb_server,
    $puppetdb_ssl_listen_address,
    $puppetdb_version,
    $report_ttl,
  )

  case $use_ssl {
    default : { $puppetdb_port = '8081' }
    false   : { $puppetdb_port = '8080' }
  }

  # setup puppetdb
  class { '::puppetdb':
    disable_ssl        => $use_ssl ? {
      default => false,
      true    => false,
      false   => true,
    },
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
