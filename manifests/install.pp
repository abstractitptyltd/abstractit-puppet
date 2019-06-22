# install client packages

class puppet::install {
  include ::puppet
  include ::puppet::defaults

  $agent_version = $::puppet::agent_version

  package { 'puppet-agent':
    ensure => $agent_version,
    notify => Class['::puppet::agent'],
  }

}
