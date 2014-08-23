# install client packages

class puppet::install (
  ) {
  include ::puppet
  $facter_version = $::puppet::facter_version
  $hiera_version  = $::puppet::hiera_version
  $puppet_version = $::puppet::puppet_version
  # Input validation
  validate_string(
    $facter_version,
    $hiera_version,
    $puppet_version,
  )
  package { 'puppetlabs-release': ensure => latest, }

  package { 'puppet-common':
    ensure  => $puppet_version,
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

  package { 'hiera': ensure => $hiera_version, }

  package { 'facter': ensure => $facter_version, }

}
