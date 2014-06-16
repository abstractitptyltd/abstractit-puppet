class puppet (
  $enabled             = true,
  $data_centre,
  $puppet_version      = 'installed',
  $hiera_version       = 'installed',
  $facter_version      = 'installed',
  $mysql_host          = '',
  $ldap_host           = '',
  $galera_cluster_name = '',
  $ldap_cluster_name   = '',
  $pub_ipaddress       = $::ipaddress,
  $host                = $puppet::params::host,
  $server              = $puppet::params::server,
  $environment         = $puppet::params::environment,
  $dumptype            = $puppet::params::dumptype,
  $devel_repo          = $puppet::params::devel_repo,
  $reports             = $puppet::params::reports,) inherits puppet::params {
  $ensure = $enabled ? {
    default => 'running',
    false   => 'stopped',
  }
  $enable = $enabled ? {
    default => true,
    false   => false,
  }

  class { 'puppet::facts':
    data_centre         => $data_centre,
    mysql_host          => $mysql_host,
    ldap_host           => $ldap_host,
    galera_cluster_name => $galera_cluster_name,
    ldap_cluster_name   => $ldap_cluster_name,
    pub_ipaddress       => $pub_ipaddress,
  }

  class { 'puppet::repo':
    devel_repo => $devel_repo,
  } ->
  class { 'puppet::install':
    puppet_version => $puppet_version,
    hiera_version  => $hiera_version,
    facter_version => $facter_version,
  } ->
  class { 'puppet::config':
    server      => $server,
    environment => $environment,
  } ~>
  class { 'puppet::agent':
    ensure => $ensure,
    enable => $enable,
  }

}
