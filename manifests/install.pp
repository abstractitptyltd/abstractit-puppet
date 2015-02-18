# install client packages

class puppet::install (
) {
  include ::puppet
  include ::puppet::defaults

  $facter_version = $::puppet::facter_version
  $hiera_version  = $::puppet::hiera_version
  $puppet_version = $::puppet::puppet_version

  $puppet_pkgs    = $::puppet::defaults::puppet_pkgs

  # Input validation
  validate_string($facter_version, $hiera_version, $puppet_version,)

  validate_array($puppet_pkgs)

  package { 'puppetlabs-release':
    ensure => latest,
  }

  package { $puppet_pkgs:
    ensure  => $puppet_version,
    require => [
      Package['puppetlabs-release'],
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
