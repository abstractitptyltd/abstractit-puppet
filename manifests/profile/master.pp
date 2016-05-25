# The puppet::profile::master class is responsible for configuring a puppetmaster.
# This profile can also setup your puppet master to talk to puppetdb and setup puppetdb
# If you want PuppetDB on a separate node please use the puppet::profile::puppetdb class
# This and the puppet::profile::puppetdb class are mutually exclusive and will not work on the same node.
#
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
# @param deep_merge_version ([String] Default: 'installed')
#   The version of the deep_merge package to install.
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
# @param hiera_merge_behavior ([String] Default: undef)
#  The type of [merge behaviour](http://docs.puppetlabs.com/hiera/latest/configuring.html#mergebehavior) that should be used by hiera. Defaults to not being set.
# @param hieradata_path (*absolute path* Default Puppet 3: /etc/puppet/hiera Default Puppet 4: $codedir/hieradata)
#   The location to configure hiera to look for the hierarchy. This also impacts the [puppet::master::modules](#public-class-puppetmastermodules) module's deployment of your r10k hiera repo.
# @param java_ram ([String] Default: '2g')
#   Set the ram to use for the new puppetserver
# @param manage_deep_merge_package ([Boolean] Default: false)
#   Whether the [deep_merge gem](https://rubygems.org/gems/deep_merge) should be installed.
# @param manage_hiera_eyaml_package ([Boolean] Default: true)
#   Whether the [hiera-eyaml gem](https://rubygems.org/gems/hiera-eyaml) should be installed.
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
# @param puppetdb [Boolean] Default: false
#   Whether to setup PuppetDB.
#   Set this to configure a PuppetDB server on this node.
# @param puppetdb_server [String] Default: undef
#   The dns name or ip of the puppetdb server.
#   Set this to specify which PuppetDB server to connect to.
#   Set it to the fqdn of this node and puppetdb to true to configure PuppetDB
# @param puppetdb_version [String] Default: 'installed'
#   The version of puppetdb to install.
# @param puppetdb_node_purge_ttl [String] Default: 0s
#   The length of time a node can be deactivated before it's deleted from the database. (a value of '0' disables purging).
# @param puppetdb_node_ttl [String] Default: '0s'
#   The length of time a node can go without receiving any new data before it's automatically deactivated. (defaults to '0', which disables auto-deactivation).
# @param puppetdb_listen_address [String] Default: 127.0.0.1
#   The address that the web server should bind to for HTTP requests. Set to '0.0.0.0' to listen on all addresses.
# @param puppetdb_ssl_listen_address [String] Default: 127.0.0.1
#   The address that the web server should bind to for HTTPS requests. Set to '0.0.0.0' to listen on all addresses.
# @param report_ttl [String] Default: '14d'
#   The length of time reports should be stored before being deleted. (defaults to 14 days).
# @param reports [Boolean] Default: true
#   A toggle to alter the behavior of reports and puppetdb.
#   If true, the module will properly set the 'reports' field in the puppet.conf file to enable the puppetdb report processor.
# @param restart_puppet [Boolean] Default: true
#   Whether to restart the puppet server instance after applying/configuring the puppetdb. Defaults to true.
# @param puppetdb_use_ssl [Boolean] Defaults: true
#   A toggle to enable or disable ssl on puppetdb connections.
# @param puppetdb_listen_port [String] Defaults: '8080'
#   Non ssl Port to use for puppetdb
# @param puppetdb_ssl_listen_port [String] Defaults: '8081'
#   Ssl Port to use for puppetdb
# @puppet_server_type [String] Defaults: 'passenger'
#   Type of puppet server set to puppetserver if using the new puppetserver

class puppet::profile::master (
  $autosign                           = false,
  $autosign_domains                   = undef,
  $autosign_file                      = undef,
  $autosign_method                    = 'file',
  $basemodulepath                     = undef,
  $deep_merge_version                 = 'installed',
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
  $manage_deep_merge_package          = false,
  $manage_hiera_eyaml_package         = true,
  $hiera_hierarchy                    = undef,
  $hiera_merge_behavior               = undef,
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
  $puppetdb                           = false,
  $puppetdb_server                    = undef,
  $puppetdb_version                   = 'installed',
  $puppetdb_node_purge_ttl            = '0s',
  $puppetdb_node_ttl                  = '0s',
  $puppetdb_listen_address            = '127.0.0.1',
  $puppetdb_ssl_listen_address        = '0.0.0.0',
  $report_ttl                         = '14d',
  $reports                            = true,
  $restart_puppet                     = true,
  $puppetdb_use_ssl                   = true,
  $puppetdb_listen_port               = '8080',
  $puppetdb_ssl_listen_port           = '8081',
  $puppet_service_name                = $server_type,
) {
  class { '::puppet::master':
    autosign                           => $autosign,
    autosign_domains                   => $autosign_domains,
    autosign_file                      => $autosign_file,
    autosign_method                    => $autosign_method,
    basemodulepath                     => $basemodulepath,
    deep_merge_version                 => $deep_merge_version,
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
    hiera_merge_behavior               => $hiera_merge_behavior,
    hieradata_path                     => $hieradata_path,
    java_ram                           => $java_ram,
    manage_hiera_config                => $manage_hiera_config,
    manage_deep_merge_package          => $manage_deep_merge_package,
    manage_hiera_eyaml_package         => $manage_hiera_eyaml_package,
    passenger_max_pool_size            => $passenger_max_pool_size,
    passenger_max_requests             => $passenger_max_requests,
    passenger_pool_idle_time           => $passenger_pool_idle_time,
    passenger_stat_throttle_rate       => $passenger_stat_throttle_rate,
    puppet_fqdn                        => $puppet_fqdn,
    server_version                     => $server_version,
    server_type                        => $server_type,
    puppet_version                     => $puppet_version,
  }

  case $puppetdb_use_ssl {
    default : {
      $puppetdb_port = $puppetdb_ssl_listen_port
      $puppetdb_disable_ssl = false
    }
    false   : {
      $puppetdb_port = $puppetdb_listen_port
      $puppetdb_disable_ssl = true
    }
  }

  # version is now managed with the puppetdb::globals class
  class { '::puppetdb::globals':
    version   => $puppetdb_version,
  }
  if ($puppetdb == true) {
    # setup puppetdb
    class { '::puppetdb':
      listen_port        => $puppetdb_listen_port,
      ssl_listen_port    => $puppetdb_ssl_listen_port,
      disable_ssl        => $puppetdb_disable_ssl,
      listen_address     => $puppetdb_listen_address,
      ssl_listen_address => $puppetdb_ssl_listen_address,
      node_ttl           => $puppetdb_node_ttl,
      node_purge_ttl     => $puppetdb_node_purge_ttl,
      report_ttl         => $report_ttl,
      require            => Class['::puppet::master'],
    }
  }
  if ($puppetdb_server != undef) {
    $_server_type = $server_type ? {
        'puppetserver' => 'puppetserver',
        default        => 'httpd',
    }
    # setup puppetdb config for puppet master
    class { '::puppetdb::master::config':
      puppetdb_port           => $puppetdb_port,
      puppetdb_server         => $puppetdb_server,
      puppetdb_disable_ssl    => $puppetdb_disable_ssl,
      puppet_service_name     => $_server_type,
      enable_reports          => $reports,
      manage_report_processor => $reports,
      restart_puppet          => $restart_puppet,
    }
  }

}
