## class puppet::master::install

class puppet::master::install (
  $puppet_version = $puppet::params::puppet_version,
  $r10k_version = $puppet::params::r10k_version,
  $gpgme_version = $puppet::params::gpgme_version,
  $hiera_gpg_version = $puppet::params::hiera_gpg_version,
) inherits puppet::params {

  package { 'puppetmaster':
    ensure  => $puppet_version,
  }
  service { 'puppetmaster':
    ensure  => stopped,
    enable  => false,
    require => Package['puppetmaster']
  }
  package { 'puppetmaster-passenger':
    ensure  => $puppet_version,
    require => [
      Package['puppetmaster'],
      Service['puppetmaster'],
    ]
  }

  # install some needed gems
  package { 'r10k':
    ensure   => $r10k_version,
    provider => gem,
  }
  package { 'gpgme':
    ensure   => $gpgme_version,
    provider => gem,
  }
  package { 'hiera-gpg':
    ensure   => $hiera_gpg_version,
    provider => gem,
  }

}
