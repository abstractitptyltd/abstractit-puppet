## install client packages

class puppet::install (
  $puppet_version = $puppet::params::puppet_version,
  $hiera_version = $puppet::params::hiera_version,
  $facter_version = $puppet::params::facter_version,
) inherits puppet::params {

  package { 'puppetlabs-release':
    ensure => latest,
  }
  package { 'puppet-common':
    ensure => $puppet_version,
    require => Package['puppetlabs-release']
  }
  package { 'puppet':
    ensure  => $puppet_version,
    require => [
      Package['puppet-common'],
      Package['hiera'],
      Package['facter'],
    ]
  }
  package { 'hiera':
    ensure => $hiera_version,
  }
  package { 'facter':
    ensure => $facter_version,
  }

}
