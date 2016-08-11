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

  file { "${facterbasepath}/facts.d/local.yaml":
    ensure       => file,
    owner        => 'root',
    group        => 'puppet',
    mode         => '0640',
    validate_cmd => "/usr/bin/env ruby -ryaml -e \"YAML.load_file '%'\"",
    content      => template('puppet/local_facts.yaml.erb'),
  }

}
