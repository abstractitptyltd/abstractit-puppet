# == Class: puppet::master::install::standard
#
# Install the puppetmaster packages from standard package provider sources (apt
# on ubuntu, etc). Also handles turning off the default puppetmaster service
# because we're going to run Apache with mod_passenger instead.
#
# === Parameters
#
# [*puppet_version*]
#   Version of Puppet to install.
#   (default: installed)
#
class puppet::master::install::standard (
  $puppet_version = $puppet::master::env::puppet_version,
) inherits puppet::master::env {

  validate_string(
    $puppet_version,
  )

  # Install (or uninstall?) the puppetmaster standard packages (not gems).
  package {
    'puppetmaster':
    ensure  => $puppet_version,
    notify  => Service['puppetmaster'];
  }

  # Disable the standard service thats installed by the above packages.
  service { 'puppetmaster':
    ensure  => stopped,
    enable  => false,
    require => Package['puppetmaster'];
  }

  package { 'puppetmaster-passenger':
    ensure  => $puppet_version,
    require => [
      Package['puppetmaster'],
      Service['puppetmaster']
    ];
  }

  # Purge any automatically installed apache puppetmaster config files
  file {
    '/etc/apache2/sites-enabled/puppetmaster.conf':
    ensure  => absent,
    require => Package['puppetmaster-passenger'];

    '/etc/apache2/sites-available/puppetmaster.conf':
    ensure  => absent,
    require => Package['puppetmaster-passenger'];
  }
}
