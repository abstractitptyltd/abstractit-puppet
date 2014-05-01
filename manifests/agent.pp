## puppet agent service

class puppet::agent (
  $enabled = $puppet::params::enabled
) inherits puppet::params {

  service { 'puppet':
    ensure => $enabled,
    enable => $enabled,
    require => Class['puppet::config']
  }

  monit::process{ 'puppet':
    ensure  => $enabled,
    pidfile => '/var/run/puppet/agent.pid',
    require => Service['puppet']
  }

}
