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

  # if we are currently running puppet v4 or upgrading to it
  if versioncmp($::puppetversion, '4.0.0') >= 0 or $puppet::allinone {
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
    $terminus_package          = 'puppetdb-termini'
    $puppetdb_etcdir           = '/etc/puppetlabs/puppetdb'
    $puppetdb_test_url         = '/pdb/meta/v1/version'
    $gem_provider              = 'puppetserver_gem'
    $puppet_group              = 'root'
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
    $terminus_package          = 'puppetdb-terminus'
    $puppetdb_etcdir           = '/etc/puppetdb'
    $puppetdb_test_url         = '/v3/version'
    $gem_provider              = 'gem'
    $puppet_group              = 'puppet'
  }
  $puppetdb_confdir          = "${puppetdb_etcdir}/conf.d"
  $puppetdb_ssl_dir          = "${puppetdb_etcdir}/ssl"
  $autosign_file             = "${confdir}/autosign.conf"
  $environmentpath           = "${codedir}/environments"
  $hiera_eyaml_key_directory = "${codedir}/hiera_eyaml_keys"
  $hieradata_path            = "${confdir}/hieradata"

}
