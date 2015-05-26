# The puppet::master class is responsible for performing some input validation, and subsequently configuring a puppetmaster.
# This is done internally via the puppet::master::config, puppet::master::hiera, pupppet::master::install
# and puppet::master::passenger classes.

# @param autosign [Boolean] Default: false
#   Whether or not to enable autosign.
# @param basemodulepath (*absolute path* Default Puppet 4: ${codedir}/environments Default Puppet 3: /etc/puppet/environments)
#   The base directory path to have environments checked out into.
# @param env_owner [String] Default: 'puppet'
#   The user which should own hieradata and r10k repos

# @param environmentpath (*absolute path* Default Puppet 4: ${codedir}/modules:${confdir}/modules Default Puppet 3: ${confdir}/modules:/usr/share/puppet/modules)
#   The base directory path to have environments checked out into.

# @param eyaml_keys ([Boolean] Default: false)
#   Toggle whether or not to deploy [eyaml](https://github.com/TomPoulton/hiera-eyaml) keys

# @param future_parser ([Boolean] Default: false)
#   Toggle to dictate whether or not to enable the [future parser](http://docs.puppetlabs.com/puppet/latest/reference/experiments_future.html)

# @param hiera_backends ([Hash] Default Puppet 3: {'yaml' => { 'datadir' => '/etc/puppet/hiera/%{environment}',} } Default Puppet 4: {'yaml' => { 'datadir' => '$codedir/hieradata/%{environment}',} })
#   The backends to configure hiera to query.

# @param hiera_eyaml_version ([String] Default: 'installed')
#   The version of the hiera-eyaml package to install. *It is important to note that the hiera-eyaml package will be installed via gem*

# @param hiera_hierarchy ([Array] Default: ['node/%{::clientcert}', 'env/%{::environment}', 'global'])
#   The hierarchy to configure hiera to use

# @param hieradata_path (*absolute path* Default Puppet 3: /etc/puppet/hiera Default Puppet 4: $codedir/hieradata)
#   The location to configure hiera to look for the hierarchy. This also impacts the [puppet::master::modules](#public-class-puppetmastermodules) module's deployment of your r10k hiera repo.

# @param java_ram ([String] Default: '2g')
#   Set the ram to use for the new puppetserver

# @param passenger_max_pool_size ([Number] Default: 12)
#   Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [max pool size](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerMaxPoolSize).

# @param passenger_max_requests ([Number] Default: 0)
#   Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [max requests](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerMaxRequests).

# @param passenger_pool_idle_time ([Number] Default: 1500)
#   Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [pool idle time](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerPoolIdleTime)

# @param passenger_stat_throttle_rate ([Number] Default: 120)
#   Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [stat throttle rate](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#_passengerstatthrottlerate_lt_integer_gt)

# @param puppet_fqdn ([String] Default: $::fqdn)
#   Sets the namevar of the [apache::vhost](https://github.com/puppetlabs/puppetlabs-apache#defined-type-apachevhost) resource declared. It is also used to derive the ssl_cert and ssl_key parameters to the apache::vhost resource.

# @param puppet_server ([String] Default: $::fqdn)
#   Changing this does not appear to do anything.

# @param puppet_version ([String] Default: 'installed')
#   Specifies the version of the puppetmaster package to install

# @param server_type ([String] Default Puppet 4: 'puppetserver' Default Puppet 4: 'passenger')
#   Specifies the type of server to use puppetserver is always used on Puppet 4

# @param module_path **DEPRECATED** ([String] Default: undef)
#   If this is set, it will be used to populate the basemodulepath parameter in /etc/puppet/puppet.conf. This does not impact [environment.conf](http://docs.puppetlabs.com/puppet/latest/reference/config_file_environment.html), which should live in your [r10k](https://github.com/adrienthebo/r10k) environment repo.

# @param pre_module_path **DEPRECATED** ([String] Default: undef)
#   If set, this is prepended to the modulepath parameter *if it is set* and to a static modulepath list if modulepath is unspecified. *A colon separator will be appended to the end of this if needed*

# @param r10k_version **DEPRECATED** ([String] Default: undef)
#   Specifies the version of r10k to install. *It is important to note that the r10k package will be installed via gem*

class puppet::master (
  $autosign                     = false,
  $basemodulepath               = $::puppet::defaults::basemodulepath,
  $env_owner                    = 'puppet',
  $environmentpath              = $::puppet::defaults::environmentpath,
  $environment_timeout          = '0',
  $eyaml_keys                   = false,
  $future_parser                = false,
  $hiera_backends               = $::puppet::defaults::hiera_backends,
  $hiera_eyaml_version          = 'installed',
  $hiera_hierarchy              = [
    'node/%{::clientcert}',
    'env/%{::environment}',
    'global'],
  $hieradata_path               = $::puppet::defaults::hieradata_path,
  $java_ram                     = '2g',
  $passenger_max_pool_size      = '12',
  $passenger_max_requests       = '0',
  $passenger_pool_idle_time     = '1500',
  $passenger_stat_throttle_rate = '120',
  $puppet_fqdn                  = $::fqdn,
  $puppet_server                = $::fqdn,
  $puppet_version               = 'installed',
  $server_type                  = $::puppet::defaults::server_type,
  $server_version               = 'installed',
  $module_path                  = undef,
  $pre_module_path              = undef,
  $r10k_version                 = undef,
) inherits ::puppet::defaults {

  #input validation
  validate_absolute_path(
    $environmentpath,
    $hieradata_path,
  )
  validate_array(
    $hiera_hierarchy,
  )

  validate_bool(
    $autosign,
    $eyaml_keys,
    $future_parser,
  )

  validate_hash(
    $hiera_backends
  )

  validate_string(
    $env_owner,
    $environment_timeout,
    $hiera_eyaml_version,
    $puppet_fqdn,
    $puppet_server,
    $puppet_version,
    $server_version,
    $passenger_max_pool_size,
    $passenger_max_requests,
    $passenger_pool_idle_time,
    $passenger_stat_throttle_rate,
  )

  # add deprecation warnings
  if $r10k_version != undef {
    notify { 'Deprecation notice: puppet::master::r10k_version is deprecated, use puppet::profile::r10k class instead': }
  }
  if $module_path != undef {
    notify { 'Deprecation notice: puppet::master::module_path is deprecated, use puppet::master::basemodulepath instead': }
  }
  if $pre_module_path != undef {
    notify { 'Deprecation notice: puppet::master::pre_module_path is deprecated, use puppet::master::basemodulepath instead': }
  }

  include ::puppet::master::install
  include ::puppet::master::config
  include ::puppet::master::hiera

  case $server_type {
    'puppetserver': {
      include ::puppet::master::server
      # Class['puppet::master::hiera'] ~>
      # Class['puppet::master::server']
    }
    default: {
      include ::puppet::master::passenger
      # Class['puppet::master::hiera'] ~>
      # Class['puppet::master::passenger']
    }
  }

  Class['puppet::master::install'] ->
  Class['puppet::master::config'] ->
  Class['puppet::master::hiera']

}
