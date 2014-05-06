## class puppet::master::puppetdb

class puppet::master::puppetdb (
  $node_ttl = $puppet::params::node_ttl,
  $node_purge_ttl = $puppet::params::node_purge_ttl,
  $report_ttl = $puppet::params::report_ttl,
  $host = $puppet::params::host,
  $reports = $puppet::params::reports,
  $puppetdb_version = $puppet::params::puppetdb_version,
) inherits puppet::params {

  # setup puppetdb
  class { '::puppetdb':
    ssl_listen_address => '0.0.0.0',
    node_ttl           => $node_ttl,
    node_purge_ttl     => $node_purge_ttl,
    report_ttl         => $report_ttl,
    puppetdb_version   => $puppetdb_version,
    require            => Class['puppet::master'],
  }
  class { '::puppetdb::master::config':
    puppet_service_name     => 'httpd',
    puppetdb_server         => $host,
    enable_reports          => $reports,
    manage_report_processor => $reports,
    restart_puppet          => false,
    require                 => Class['puppetdb'],
  }

  # cleanup old puppet reports
  cron { 'puppet clean reports':
    command => 'cd /var/lib/puppet/reports && find . -type f -name \*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f',
    user => root,
    hour => 21,
    minute => 22,
    weekday => 0,
  }

}
