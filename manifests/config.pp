## class puppet::config
# config for puppet agent

class puppet::config (
  $server = $puppet::params::server,
  $environment = $puppet::params::environment,
) inherits puppet::params {

  ini_setting { 'puppet client server':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'server',
    value   => $server,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client environment':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'environment',
    value   => $environment,
    require => Class['puppet::install'],
  }

}
