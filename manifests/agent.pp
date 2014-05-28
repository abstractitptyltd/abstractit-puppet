# # puppet agent service

class puppet::agent (
  $enable = $puppet::params::enable,
  $ensure = $puppet::params::ensure,) inherits puppet::params {
  service { 'puppet':
    ensure  => $ensure,
    enable  => $enable,
    require => Class['puppet::config']
  }

  monit::process { 'puppet':
    ensure  => $enabled,
    pidfile => '/var/run/puppet/agent.pid',
    require => Service['puppet']
  }

}
