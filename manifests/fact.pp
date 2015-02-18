# Define: puppet::fact
#
# define for setting facts using facter.d
#

define puppet::fact (
  $value,
  $ensure = present,
  ) {
  file { "/etc/facter/facts.d/${title}.yaml":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/fact.yaml.erb'),
  }

}
