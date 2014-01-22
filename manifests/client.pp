# Class: puppet::client
#
# Setup a puppet client
#
# setup facts and puppet agent
#
class puppet::client (
  $data_centre,
  $pub_ipaddress = $::ipaddress,
  $enabled = true,
) {

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

  file {"/etc/facter/facts.d/local.yaml":
    ensure    => file,
    owner     => 'root',
    group     => 'puppet',
    mode      => '0640',
    content   => template('puppet/local_facts.yaml.erb'),
  }

  service { 'puppet':
    ensure => $enabled,
    enable => $enabled,
  }

  ## realise puppet facts
  File <<| tag == 'puppet_fact_global' |>>
  File <<| tag == "puppet_fact_${::environment}" |>>
  File <<| tag == "puppet_fact_${::data_centre}" |>>

}
