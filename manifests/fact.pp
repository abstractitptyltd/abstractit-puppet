# Define: puppet::fact
#
# define for setting facts using facter.d
#

define puppet::fact (
  $value,
  $ensure = present,
  $scope = 'data_centre',
) {

  validate_re($scope, '^data_centre|environment|global$',
  "scope ${scope} value not supported,
  valid values are data_centre, environment or global")

  $tag = $scope ? {
      default       => "puppet_fact_${::data_centre}",
      'environment' => "puppet_fact_${::environment}",
      'global'      => 'puppet_fact_global',
  }

  @@file {"/etc/facter/facts.d/${name}.yaml":
    ensure    => $ensure,
    owner     => 'root',
    group     => 'puppet',
    mode      => '0640',
    content   => template('puppet/fact.yaml.erb'),
    tag       => $tag,
  }

}
