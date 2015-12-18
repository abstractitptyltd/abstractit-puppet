# Class puppet::master::install

class puppet::master::install {
  include ::puppet
  include ::puppet::defaults
  include ::puppet::master

  $allinone                   = $::puppet::allinone
  $server_type                = $::puppet::master::server_type
  $hiera_eyaml_version        = $::puppet::master::hiera_eyaml_version
  $manage_hiera_eyaml_package = $::puppet::master::manage_hiera_eyaml_package
  $deep_merge_version         = $::puppet::master::deep_merge_version
  $manage_deep_merge_package  = $::puppet::master::manage_deep_merge_package
  $puppet_version             = $::puppet::master::puppet_version
  $puppetmaster_pkg           = $::puppet::defaults::puppetmaster_pkg
  $server_version             = $::puppet::master::server_version
  $gem_provider               = $::puppet::defaults::gem_provider

  if ($allinone == true) {
    $server_package  = 'puppetserver'
    $package_ensure  = $server_version
  } else {
    if ($server_type == 'puppetserver') {
        $server_package  = 'puppetserver'
        $package_ensure  = $server_version
      } else {
        $server_package  = $puppetmaster_pkg
        $package_ensure  = $puppet_version
      }
  }

  include ::puppet::master::install::deps

  package { $server_package:
    ensure  => $package_ensure,
    require => [
      Class[puppet::master::install::deps],
      Class[puppet::install],
    ],
  }

  if $manage_hiera_eyaml_package {
    package { 'hiera-eyaml':
      ensure   => $hiera_eyaml_version,
      provider => $gem_provider,
    }
  }

  if $manage_deep_merge_package {
    package { 'deep_merge':
      ensure   => $deep_merge_version,
      provider => $gem_provider,
    }
  }

}
