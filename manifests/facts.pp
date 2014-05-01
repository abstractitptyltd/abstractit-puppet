# Class: puppet::facts
#
# Setup a puppet facts
#
# setup facts
#

class puppet::facts (
  $data_centre = '',
  $mysql_host = '',
  $ldap_host = '',
  $galera_cluster_name = '',
  $ldap_cluster_name = '',
  $pub_ipaddress = $::ipaddress,
) inherits puppet::params {

  if ! defined(File['/etc/facter']) {
    file { '/etc/facter':
      ensure => directory,
      owner  => 'root',
      group  => 'puppet',
      mode   => '0755',
    }
  }

  if ! defined(File['/etc/facter/facts.d']) {
    file { '/etc/facter/facts.d':
      ensure => directory,
      owner  => 'root',
      group  => 'puppet',
      mode   => '0755',
    }
  }

  file {'/etc/facter/facts.d/local.yaml':
    ensure    => file,
    owner     => 'root',
    group     => 'puppet',
    mode      => '0640',
    content   => template('puppet/local_facts.yaml.erb'),
  }

  ## realise puppet facts
  File <<| tag == 'puppet_fact_global' |>>
  File <<| tag == "puppet_fact_${::environment}" |>>
  File <<| tag == "puppet_fact_${::data_centre}" |>>

}
