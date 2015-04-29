# Class puppet::master::install::deps

class puppet::master::install::deps {

  include ::puppet::master
  include ::puppet

  $puppet_version = $::puppet::master::puppet_version

  if ($::puppet::allinone == false) {
    case $::osfamily {
      'Debian': {
        package { 'puppetmaster-common':
          ensure  => $puppet_version
        }
      }
      default: {
        # no deps for non debian
      }
    }
  }
}
