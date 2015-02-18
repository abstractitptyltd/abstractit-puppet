# Include the proper subclass.

class puppet::repo {

  case $::osfamily {
    'Debian': {
      include ::puppet::repo::apt
    }
    'RedHat': {
      include ::puppet::repo::yum
    }
  }
}
