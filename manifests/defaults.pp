# Class: puppet::defaults
#
# This class manages OS specific variables for
#
# Parameters:
# - The $puppet_pkgs for each OS
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class puppet::defaults {
  case $::osfamily {
    'Debian' : {
      $puppet_pkgs       = [
        'puppet',
        'puppet-common']
      $puppetmaster_pkgs = [
        'puppetmaster',
        'puppetmaster-common']
    }
    'RedHat' : {
      $puppet_pkgs       = ['puppet']
      $puppetmaster_pkgs = ['puppet-server']
    }
    default  : {
      fail("Class['puppet::defaults']: Unsupported osfamily: ${::osfamily}")
    }
  }
}
