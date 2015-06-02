# Class puppet::install::deps

class puppet::install::deps {
  include ::puppet
  include ::puppet::defaults

  if ($::puppet::allinone == false) {
    # only install these allinone is false

    $facter_version = $::puppet::facter_version
    $hiera_version  = $::puppet::hiera_version
    # $puppet_version = $::puppet::puppet_version

    # case $::osfamily {
    #   'Debian': {
    #     package { 'puppet-common':
    #       ensure => $puppet_version,
    #       require => [
    #         Package['hiera'],
    #         Package['facter'],
    #       ]
    #     }
    #   }
    # }

    package { 'hiera':
      ensure => $hiera_version,
    }

    package { 'facter':
      ensure => $facter_version,
    }

  }

}