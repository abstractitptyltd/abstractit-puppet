# Class: puppet::client
#
# Setup a puppet client
#
# setup puppet agent
#

class puppet::client (
  $enabled = true,
  $environment = 'production',
) {

  service { 'puppet':
    ensure => $enabled,
    enable => $enabled,
  }

  monit::process{ 'puppet':
    ensure  => $enabled,
    pidfile => '/var/run/puppet/agent.pid',
  }

  ini_setting { 'puppet client environment':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'environment',
    value   => $environment,
  }

}
