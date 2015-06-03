# Class: puppet::facts
#
# Setup puppet facts
#
# setup facts
#

class puppet::facts (
  $custom_facts = undef
) {
  include ::puppet
  include ::puppet::defaults
  $facterbasepath = $::puppet::defaults::facterbasepath

  if $custom_facts {
    validate_hash($custom_facts)
  }

  if $::puppet::manage_etc_facter {
    file { $facterbasepath:
      ensure => directory,
      owner  => 'root',
      group  => 'puppet',
      mode   => '0755',
    }
  }

  if $::puppet::manage_etc_facter_facts_d {
    file { "${facterbasepath}/facts.d":
      ensure => directory,
      owner  => 'root',
      group  => 'puppet',
      mode   => '0755',
    }
  }

  file { "${facterbasepath}/facts.d/local.yaml":
    ensure  => file,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/local_facts.yaml.erb'),
  }

}
