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
      $sysconfigdir = '/etc/default'
    }
    'RedHat' : {
      $sysconfigdir = '/etc/sysconfig'
    }
    default  : {
      fail("Class['puppet::defaults']: Unsupported osfamily: ${::osfamily}")
    }
  }

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
  $puppetdb_confdir          = "${puppetdb_etcdir}/conf.d"
  $puppetdb_ssl_dir          = "${puppetdb_etcdir}/ssl"
  $autosign_file             = "${confdir}/autosign.conf"
  $environmentpath           = "${codedir}/environments"
  $hiera_eyaml_key_directory = "${codedir}/hiera_eyaml_keys"
  $hieradata_path            = "${confdir}/hieradata"

}
