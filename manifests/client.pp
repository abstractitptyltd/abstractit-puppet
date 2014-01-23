# Class: puppet::client
#
# Setup a puppet client
#
# setup puppet agent
#
class puppet::client (
  $enabled = true,
) {

  service { 'puppet':
    ensure => $enabled,
    enable => $enabled,
  }

  monit::process{ 'puppet':
    ensure  => $enabled,
    pidfile => '/var/run/puppet/agent.pid',
  }

}
