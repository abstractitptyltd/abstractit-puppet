# Class: puppet::facts
#
# Setup puppet facts
#
# setup facts
#

class puppet::facts (
  $custom_facts = undef) inherits puppet::params {
  if !defined(File['/etc/facter']) {
    file { '/etc/facter':
      ensure => directory,
      owner  => 'root',
      group  => 'puppet',
      mode   => '0755',
    }
  }

  if !defined(File['/etc/facter/facts.d']) {
    file { '/etc/facter/facts.d':
      ensure => directory,
      owner  => 'root',
      group  => 'puppet',
      mode   => '0755',
    }
  }

  file { '/etc/facter/facts.d/local.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/local_facts.yaml.erb'),
  }

}
