# The puppet::profile::master class is responsible for configuring a puppetmaster.

# @param autosign [Boolean] Default: false
#   Whether or not to enable autosign.
# @param autosign_domains [Array] Default: empty
#   array of domains to use for basic autosigning
# @param autosign_file [String] Default: $confdir/autosign.conf
#   file to use for basic autosigning
# @param autosign_method [String] Default: file
#   Method to use for autosign
#   the default 'file' will use the $confdir/autosign.conf file to determine which certs to sign.
#   This file is empty by default so autosigning will be effectivly off
#   'on' will set the autosign variable to true and thus all certs will be signed.
#   'off' will set the autosign variable to false disabling autosign completely.
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
# @param hiera_eyaml_key_directory ([String] Default $::settings::confdir/hiera_eyaml_keys)
#   Directory to store the hiera-eyaml keys
# @param hiera_eyaml_pkcs7_private_key ([String] Default: undef)
#   The location to store the hiera-eyaml private key
# @param hiera_eyaml_pkcs7_public_key ([String] Default: undef)
#   The location to store the hiera-eyaml public key
# @param hiera_eyaml_pkcs7_private_key_file ([String] Default: undef)
#   The puppet source of the file to use as the hiera-eyaml private key
# @param hiera_eyaml_pkcs7_public_key_file ([String] Default: undef)
#   The puppet source of the file to use as the hiera-eyaml private key
# @param hiera_hierarchy ([Array] Default: ['node/%{::clientcert}', 'env/%{::environment}', 'global'])
#   The hierarchy to configure hiera to use
# @param hieradata_path (*absolute path* Default Puppet 3: /etc/puppet/hiera Default Puppet 4: $codedir/hieradata)
#   The location to configure hiera to look for the hierarchy. This also impacts the [puppet::master::modules](#public-class-puppetmastermodules) module's deployment of your r10k hiera repo.
# @param java_ram ([String] Default: '2g')
#   Set the ram to use for the new puppetserver
# @param manage_hiera_config ([Boolean] Default: true)
#   Whether to manage the content of the hiera config file
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

class puppet::profile::master (
  $autosign                           = false,
  $autosign_domains                   = undef,
  $autosign_file                      = undef,
  $autosign_method                    = 'file',
  $basemodulepath                     = undef,
  $env_owner                          = 'puppet',
  $environmentpath                    = undef,
  $environment_timeout                = '0',
  $eyaml_keys                         = false,
  $future_parser                      = false,
  $hiera_backends                     = undef,
  $hiera_eyaml_key_directory          = undef,
  $hiera_eyaml_pkcs7_private_key      = 'private_key.pkcs7.pem',
  $hiera_eyaml_pkcs7_public_key       = 'public_key.pkcs7.pem',
  $hiera_eyaml_pkcs7_private_key_file = undef,
  $hiera_eyaml_pkcs7_public_key_file  = undef,
  $hiera_eyaml_version                = 'installed',
  $hiera_hierarchy                    = undef,
  $hieradata_path                     = undef,
  $java_ram                           = '2g',
  $manage_hiera_config                = true,
  $passenger_max_pool_size            = '12',
  $passenger_max_requests             = '0',
  $passenger_pool_idle_time           = '1500',
  $passenger_stat_throttle_rate       = '120',
  $puppet_fqdn                        = $::fqdn,
  $puppet_version                     = 'installed',
  $server_type                        = undef,
  $server_version                     = 'installed',
) {
  class { '::puppet::master':
    autosign                           => $autosign,
    autosign_domains                   => $autosign_domains,
    autosign_file                      => $autosign_file,
    autosign_method                    => $autosign_method,
    basemodulepath                     => $basemodulepath,
    env_owner                          => $env_owner,
    environmentpath                    => $environmentpath,
    environment_timeout                => $environment_timeout,
    eyaml_keys                         => $eyaml_keys,
    future_parser                      => $future_parser,
    hiera_backends                     => $hiera_backends,
    hiera_eyaml_key_directory          => $hiera_eyaml_key_directory,
    hiera_eyaml_pkcs7_private_key      => $hiera_eyaml_pkcs7_private_key,
    hiera_eyaml_pkcs7_public_key       => $hiera_eyaml_pkcs7_public_key,
    hiera_eyaml_pkcs7_private_key_file => $hiera_eyaml_pkcs7_private_key_file,
    hiera_eyaml_pkcs7_public_key_file  => $hiera_eyaml_pkcs7_public_key_file,
    hiera_eyaml_version                => $hiera_eyaml_version,
    hiera_hierarchy                    => $hiera_hierarchy,
    hieradata_path                     => $hieradata_path,
    java_ram                           => $java_ram,
    manage_hiera_config                => $manage_hiera_config,
    passenger_max_pool_size            => $passenger_max_pool_size,
    passenger_max_requests             => $passenger_max_requests,
    passenger_pool_idle_time           => $passenger_pool_idle_time,
    passenger_stat_throttle_rate       => $passenger_stat_throttle_rate,
    puppet_fqdn                        => $puppet_fqdn,
    server_version                     => $server_version,
    server_type                        => $server_type,
    puppet_version                     => $puppet_version,
  }

}
