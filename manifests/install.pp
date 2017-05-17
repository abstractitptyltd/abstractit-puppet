# install client packages

class puppet::install {
  include ::puppet
  include ::puppet::defaults

  $allinone        = $::puppet::allinone
  $agent_version   = $::puppet::agent_version
  $puppet_version  = $::puppet::puppet_version

  if ($allinone) {
    $agent_package  = 'puppet-agent'
    $package_ensure = $agent_version
  } else {
    $agent_package  = 'puppet'
    $package_ensure = $puppet_version
  }

  include ::puppet::install::deps

  package { $agent_package:
    ensure  => $package_ensure,
    require => Class['::puppet::install::deps'],
    notify  => Class['::puppet::agent'],
  }

}
