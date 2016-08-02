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

  unless is_string($value) or is_array($value) or is_hash($value) {
    warning("Param \$value of resource Puppet::Fact['${title}'] must be Sring or Array or Hash!")
  }

  file { "${facterbasepath}/facts.d/${title}.yaml":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/fact.yaml.erb'),
  }

}
