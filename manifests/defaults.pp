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
      $sysconfigdir       = '/etc/default'
    }
    'RedHat' : {
      $puppetmaster_pkg   = 'puppet-server'
      $sysconfigdir       = '/etc/sysconfig'
    }
    default  : {
      fail("Class['puppet::defaults']: Unsupported osfamily: ${::osfamily}")
    }
  }

  if ( versioncmp($::puppetversion, '4.0.0') >= 0 ) {
    $server_type               = 'puppetserver'
    $confdir                   = '/etc/puppetlabs/puppet'
    $codedir                   = '/etc/puppetlabs/code'
    $basemodulepath            = "${codedir}/modules:${confdir}/modules"
    $hiera_backends            = {
      'yaml' => {
        'datadir' => '/etc/puppetlabs/code/hieradata/%{environment}'
      }
    }
    $facterbasepath            = '/opt/puppetlabs/facter'
    $reports_dir               = '/opt/puppetlabs/server/data/reports'
  } else {
    $server_type               = 'passenger'
    $confdir                   = '/etc/puppet'
    $codedir                   = '/etc/puppet'
    $basemodulepath            = "${confdir}/modules:/usr/share/puppet/modules"
    $hiera_backends            = {
      'yaml' => {
        'datadir' => '/etc/puppet/hieradata/%{environment}'
      }
    }
    $facterbasepath            = '/etc/facter'
    $reports_dir               = '/var/lib/puppet/reports'
  }
  $autosign_file             = "${confdir}/autosign.conf"
  $environmentpath           = "${codedir}/environments"
  $hiera_eyaml_key_directory = "${codedir}/hiera_eyaml_keys"
  $hieradata_path            = "${confdir}/hieradata"

}
