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
  $owner_group = $::puppet::owner_group

  if $custom_facts {
    validate_hash($custom_facts)
  }

  file { "${facterbasepath}/facts.d/local.yaml":
    ensure  => file,
    owner   => 'root',
    group   => $owner_group,
    mode    => '0640',
    content => template('puppet/local_facts.yaml.erb'),
  }

}
