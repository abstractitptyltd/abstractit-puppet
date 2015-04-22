# Include the proper subclass.

class puppet::repo {

  package { 'puppetlabs-release':
    ensure => latest,
  }
  if $::puppet::collection != undef {
    package { "puppetlabs-release-${::puppet::collection}":
      ensure => latest,
    }
  }

  case $::osfamily {
    'Debian': {
      include ::puppet::repo::apt
    }
    'RedHat': {
      include ::puppet::repo::yum
    }
    default  : {
      warning("Class['puppet::repo']: Unsupported osfamily: ${::osfamily} your repositories won't be managed")
    }
  }
}
