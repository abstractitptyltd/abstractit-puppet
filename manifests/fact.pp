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

  validate_re($title, '^[0-9A-Za-z_\-]+$', 'The $title fact does not match ^[0-9A-Za-z_\-]+$')
  $facter_data = { "${title}" => $value }

  file { "${facterbasepath}/facts.d/${title}.yaml":
    ensure       => $ensure,
    owner        => 'root',
    group        => 'puppet',
    mode         => '0640',
    validate_cmd => "/usr/bin/env ruby -ryaml -e \"YAML.load_file '%'\"",
    content      => template('puppet/fact.yaml.erb'),
  }

}
