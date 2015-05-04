# Class puppet::profile::puppetdb

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
