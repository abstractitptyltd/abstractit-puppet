# Class puppet::master::install

class puppet::master::install {
  include ::puppet::master
  $hiera_eyaml_version = 'installed'
  $puppet_version = 'installed'
  $r10k_version   = 'installed'

  validate_string(
    $hiera_eyaml_version,
    $puppet_version,
    $r10k_version
  )

  package { 'puppetmaster-common':
    ensure  => $puppet_version,
    require => Package['puppet']
  }

  package { 'puppetmaster':
    ensure  => $puppet_version,
    require => Package['puppetmaster-common']
  }

  service { 'puppetmaster':
    ensure  => stopped,
    enable  => false,
    require => Package['puppetmaster'],
  }

  file { '/etc/apache2/sites-enabled/puppetmaster.conf':
    ensure  => absent,
    require => Package['puppetmaster-passenger']
  }

  file { '/etc/apache2/sites-available/puppetmaster.conf':
    ensure  => absent,
    require => Package['puppetmaster-passenger']
  }

  package { 'puppetmaster-passenger':
    ensure  => $puppet_version,
    require => [
      Package['puppetmaster'],
      Service['puppetmaster']]
  }

  # install some needed gems
  package { 'r10k':
    ensure   => $r10k_version,
    provider => gem
  }

  package { 'hiera-eyaml':
    ensure   => $hiera_eyaml_version,
    provider => gem
  }

}
