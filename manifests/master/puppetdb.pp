# # class puppet::master::puppetdb

class puppet::master::puppetdb (
  $puppetdb_version,
  $node_ttl       = $puppet::master::params::node_ttl,
  $node_purge_ttl = $puppet::master::params::node_purge_ttl,
  $report_ttl     = $puppet::master::params::report_ttl,
  $host           = $puppet::master::params::host,
  $reports        = $puppet::master::params::reports,) inherits puppet::master::params {
  monit::process { 'puppetdb':
    host     => '127.0.0.1',
    port     => '8080',
    protocol => 'HTTP',
  }

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
    puppetdb_version        => $puppetdb_version,
    require                 => Class['puppetdb'],
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
