# Include the proper subclass.

class puppet::repo {

  case $::osfamily {
    'Debian': {
      include ::puppet::repo::apt
    }
  }
}
