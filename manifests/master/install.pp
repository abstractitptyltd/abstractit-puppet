# Class puppet::master::install

class puppet::master::install {
  include ::puppet
  include ::puppet::defaults
  include ::puppet::master

  $hiera_eyaml_version        = $::puppet::master::hiera_eyaml_version
  $manage_hiera_eyaml_package = $::puppet::master::manage_hiera_eyaml_package
  $deep_merge_version         = $::puppet::master::deep_merge_version
  $manage_deep_merge_package  = $::puppet::master::manage_deep_merge_package
  $server_version             = $::puppet::master::server_version
  $gem_provider               = $::puppet::defaults::gem_provider

  package { 'puppetserver':
    ensure  => $server_version,
    require => [
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
