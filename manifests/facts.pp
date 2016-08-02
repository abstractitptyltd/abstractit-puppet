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

  if ( versioncmp($::puppetversion, '4.0.0') >= 0 ) {
    $custom_facts.each |$custom_fact, $custom_fact_value| {
      unless is_string($custom_fact_value) or is_array($custom_fact_value) or is_hash($custom_fact_value) {
        warning("Value of custom fact '${custom_fact}' must be Sring or Array or Hash!")
      }
    }
  } else {
    $custom_facts_values = values($custom_facts)
    ::puppet::facts::validation { $custom_facts_values: }
  }

  file { "${facterbasepath}/facts.d/local.yaml":
    ensure  => file,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0640',
    content => template('puppet/local_facts.yaml.erb'),
  }

}
