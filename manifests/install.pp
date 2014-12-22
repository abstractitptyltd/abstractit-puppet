# install client packages

class puppet::install (
  $facter_version = $puppet::env::facter_version,
  $hiera_version  = $puppet::env::hiera_version,
  $puppet_version = $puppet::env::puppet_version
) inherits puppet::env {

  # Input validation
  validate_string(
    $facter_version,
    $hiera_version,
    $puppet_version,
  )

  package {
    'puppetlabs-release':
    ensure => latest;

    'hiera':
    ensure  => $hiera_version,
    require => Package['puppetlabs-release'];

    'facter':
    ensure => $facter_version,
    require => Package['puppetlabs-release'];

    'puppet-common':
    ensure  => $puppet_version,
    require => [
      Package['hiera'],
      Package['facter'],
    ];

    'puppet':
    ensure  => $puppet_version,
    require => Package['puppet-common'];
  }
}
