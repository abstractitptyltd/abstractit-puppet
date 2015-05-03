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
      $puppetmaster_pkg   = 'puppetmaster'
      $sysconfigdir       = '/etc/defaults'
    }
    'RedHat' : {
      $puppetmaster_pkg   = 'puppet-server'
      $sysconfigdir       = '/etc/sysconfig'
    }
    default  : {
      fail("Class['puppet::defaults']: Unsupported osfamily: ${::osfamily}")
    }
  }

  $environmentpath = "${settings::confdir}/environments"
  if ( versioncmp($::puppetversion, '4.0.0') >= 0 ) {
    $server_type    = 'puppetserver'
    $basemodulepath = "${settings::codedir}/modules:${settings::confdir}/modules"
    $hieradata_path = "${settings::codedir}/hieradata"
    $hiera_backends = {
      'yaml' => {
        'datadir' => '/opt/puppetlabs/code/hieradata/%{environment}'
      }
    }
    $facterbasepath = '/opt/puppetlabs/facter'
  } else {
    $server_type    = 'passenger'
    $basemodulepath = "${settings::confdir}/modules:/usr/share/puppet/modules"
    $hieradata_path = "${settings::confdir}/hieradata"
    $hiera_backends = {
      'yaml' => {
        'datadir' => '/etc/puppet/hieradata/%{environment}'
      }
    }
    $facterbasepath = '/etc/facter'
  }
}
