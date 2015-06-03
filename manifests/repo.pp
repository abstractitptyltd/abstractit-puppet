# Include the proper subclass.

class puppet::repo {

  package { 'puppetlabs-release':
    ensure => latest,
  }
  if $::puppet::collection != undef {
    $lc_collection_name = downcase($puppet::collection)
    package { "puppetlabs-release-${lc_collection_name}":
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
