# Class puppet::master::install

class puppet::master::install {
  include ::puppet
  include ::puppet::defaults
  include ::puppet::master

  $allinone            = $::puppet::allinone
  $hiera_eyaml_version = $::puppet::master::hiera_eyaml_version
  $puppet_version      = $::puppet::master::puppet_version
  $puppetmaster_pkg    = $::puppet::defaults::puppetmaster_pkg
  $server_version      = $::puppet::master::server_version

  if ($allinone) {
    $server_package  = 'puppetserver'
    $package_ensure  = $server_version
  } else {
    $server_package  = $puppetmaster_pkg
    $package_ensure  = $puppet_version
  }

  include ::puppet::master::install::deps

  package { $server_package:
    ensure  => $package_ensure,
    require => [
      Class[puppet::master::install::deps],
      Class[puppet::install],
    ],
  }

  package { 'hiera-eyaml':
    ensure   => $hiera_eyaml_version,
    provider => gem
  }

}
