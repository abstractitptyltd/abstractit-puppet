# Define: puppet::fact
#
# define for setting facts using facter.d
#

define puppet::fact (
  $ensure = present,
  $value  = undef,
) {
  include ::puppet::defaults
  $facterbasepath = $::puppet::defaults::facterbasepath

  validate_re($title, '^[0-9A-Za-z_\-]+$', 'The $title fact does not match ^[0-9A-Za-z_\-]+$')
  $facter_data = { "${title}" => $value }

  file { "${facterbasepath}/facts.d/${title}.yaml":
    ensure  => $ensure,
    owner   => 'root',
    group   => $::puppet::defaults::puppet_group,
    mode    => '0640',
    content => template('puppet/fact.yaml.erb'),
  }

}
