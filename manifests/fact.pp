# Define: puppet::fact
#
# define for setting facts using facter.d
#

define puppet::fact (
  $value,
  $ensure = present,
  ) {
  include ::puppet::defaults
  $facterbasepath = $::puppet::defaults::facterbasepath

  file { "${facterbasepath}/facts.d/${title}.yaml":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/fact.yaml.erb'),
  }

}
