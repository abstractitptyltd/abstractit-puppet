## class puppet::master::install

class puppet::master::install (
  $puppet_version = $puppet::master::params::puppet_version,
  $puppetdb_version = $puppet::master::params::puppetdb_version,
  $r10k_version = $puppet::master::params::r10k_version,
  $gpgme_version = $puppet::master::params::gpgme_version,
  $hiera_gpg_version = $puppet::master::params::hiera_gpg_version,
) inherits puppet::master::params {

  package { 'puppetmaster-common':
    ensure  => $puppet_version,
    require => Package['puppet'],
  }
  package { 'puppetmaster':
    ensure  => $puppet_version,
    require => Package['puppetmaster-common']
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
  package { 'system_timer':
    ensure   => installed,
    provider => gem,
  }

}
