# Include the proper subclass.

class puppet::repo {

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
