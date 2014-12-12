# == Class: puppet::master::install
#
# Handles installing Puppet, Passenger, and the Rack Config files.
#
class puppet::master::install (
  $hiera_eyaml_version = $puppet::master::env::hiera_eyaml_version,
  $puppet_version      = $puppet::master::env::puppet_version,
  $r10k_version        = $puppet::master::env::r10k_version,
) inherits puppet::master::env {

  validate_string(
    $hiera_eyaml_version,
    $puppet_version,
    $r10k_version
  )

  # install some needed gems
  package {
    'r10k':
    ensure   => $r10k_version,
    provider => gem;

    'hiera-eyaml':
    ensure   => $hiera_eyaml_version,
    provider => gem;
  }

  # Install Puppet via the standard Puppet 3.x package names (ie,
  # puppetmaster, puppetmaster-common, etc).
  class { 'puppet::master::install::standard':
    puppet_version => $puppet_version
  }
  contain puppet::master::install::standard

  # Configure the rack application directory and the puppet master config.ru
  # file.
  class { 'puppet::master::rack':
    require => Class['puppet::master::install::standard']
  }
  contain puppet::master::rack
}
