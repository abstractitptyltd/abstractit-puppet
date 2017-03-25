# Define: puppet::fact
#
# define for setting facts using facter.d
#

define puppet::fact (
  $value,
  $ensure = present,
  ) {
  include ::puppet
  include ::puppet::defaults
  $facterbasepath = $::puppet::defaults::facterbasepath
  $owner_group = $::puppet::owner_group

  file { "${facterbasepath}/facts.d/${title}.yaml":
    ensure  => $ensure,
    owner   => 'root',
    group   => $owner_group,
    mode    => '0640',
    content => template('puppet/fact.yaml.erb'),
  }

}
