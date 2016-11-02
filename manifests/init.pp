# The main puppet class is responsible for validating some of our parameters,
# and instantiating the puppet::facts, puppet::repo, pupppet::install,
# puppet::config and puppet::agent classes.
#
# @puppet when declaring the puppet class
#   include puppet
#
# @param allinone [Boolean] Default: false
#   Whether to use the new collections
# @param agent_cron_hour [String] Default: '*'
#   The hour to run the agent cron. Valid values are `0-23`
# @param agent_cron_min [String/Array] Default: 'two_times_an_hour'
#   This param accepts any value accepted by the [cron native type](http://docs.puppetlabs.com/references/latest/type.html#cron-attribute-minute),
#   as well as two special options: `two_times_an_hour`, and `four_times_an_hour`.
#   These specials use [fqdn_rand](http://docs.puppetlabs.com/references/latest/function.html#fqdnrand)
#   to generate a random minute array on the selected interval.
#   This should distribute the load more evenly on your puppetmasters.
# @param agent_version [String] Default: 'installed'
#   Declares the version of the puppet-agent all-in-one package to install.
# @param ca_server [String] Default: undef
#   Server to use as the CA server for all agents.
# @param cfacter [Boolean] Default: false
#   Whether or not to use cfacter instead of facter.
# @param collection [String] Default: undef
#   Declares the collection repository to use.
# @param custom_facts [Hash] Default: undef
#   A hash of custom facts to setup using the ::puppet::facts define.
# @param devel_repo [Boolean] Default: false
#   deprecated Use enable_devel_repo instead
# @param enabled [Boolean] Default: true
#   Used to determine if the puppet agent should be running
# @param enable_devel_repo [Boolean] Default: false
#   This param will replace `devel_repo` in 2.x.
#   It conveys to puppet::repo::apt whether or not to add the devel apt repo source.
#   When `devel_repo` is false, `enable_devel_repo` is consulted for enablement.
#   This gives `devel_repo` backwards compatability at the cost of some confusion if you set `devel_repo` to true, and `enable_devel_repo` to false.
# @param enable_mechanism [String] Default: 'service'
#   A toggle which permits the option of running puppet as a service, or as a cron job.
# @param enable_repo [Boolean] Default: true
#   if `manage_repos` is true, this determines whether or not the puppetlabs' repository should be present.
#   *This is not consulted in any way if `manage_repos` is false*
# @param environment [String] Default: 'production'
#   Sets the puppet environment
# @param facter_version [String] Default: 'installed'
#   Declares the version of facter to install.
# @param hiera_version [String] Default: 'installed'
#   Declares the version of hiera to install.
# @param manage_etc_facter [Boolean] Default: true
#   Whether or not this module should manage the `/etc/facter` directory
# @param manage_etc_facter_facts_d [Boolean] Default: true
#   Whether or not this module should manage the `/etc/facter/facts.d` directory
# @param manage_repos [Boolean] Default: true
#   Whether or not we pay any attention to managing repositories.
#   This is managed by only including [puppet::repo](#private-class-puppetrepo) subclass when true.
#   The individual repo subclasses also will perform no action if included with this param set to false.
# @param manage_repo_method [Boolean] Default: 'file'
#   Sets the method for managing the repo files
# @param puppet_server [String] Default: 'puppet'
#   The hostname or fqdn of the puppet server that the agent should communicate with.
# @param preferred_serialization_format [String] Default: 'pson'
#   The serialization format to use for communication with the puppet server.
#   WARNING: Setting this to msgpack is experimental! Please enable with care.
# @param puppet_version [String] Default: 'installed'
#   The version of puppet to install
# @param reports [Boolean] Default: true
#   Whether or not to send reports
# @param runinterval [String] Default: '30m'
#   Sets the runinterval in puppet.conf
# @param splay [Boolean] Default: false
#   Sets the splay parameter in puppet.conf
# @param splaylimit [String] Default: undef
#   Sets the splaylimit parameter in puppet.conf
# @param structured_facts [Boolean] Default: false
#   Sets whether or not to enable [structured_facts](http://docs.puppetlabs.com/facter/2.0/fact_overview.html)
#   by setting the [stringify_facts](http://docs.puppetlabs.com/references/3.6.latest/configuration.html#stringifyfacts)
#   variable in puppet.conf.
#   **It is important to note that this boolean operates in reverse.
#   ** Setting stringify_facts to **false** is required to **permit** structured facts.
#   This is why this parameter does not directly correlate with the configuration key.
# @param use_srv_records [Boolean] Default: false
#   Enables the use of SRV records for Puppetmaster/CA selection
#   **If set to true srv_domain must also be set. This also ignores
#   puppet_server value and removes it from puppet.conf
# @param srv_domain [String] Default: undef
#   Chooses the domain to use if use_srv_records is set to true. Required if
#   use_srv_records is true.
# @param pluginsource [String] Default: undef
#   Specifies what server to use for syncing plugins. This is useful if you are
#   using SRV records and still have agents on < 4.0 as pluginsync will fail
#   unless set to a specific value (See
#   https://tickets.puppetlabs.com/browse/PUP-1035)
# @param pluginfactsource [String] Default: undef
#   If specified it will set the pluginfactsource value in puppet.conf. This is
#   useful if you are using SRV records and still have agents on < 4.0 as
#   pluginfactsync will fail to run using the default value (See
#   https://tickets.puppetlabs.com/browse/PUP-1035)

class puppet (
  $allinone                       = false,
  $agent_cron_hour                = '*',
  $agent_cron_min                 = 'two_times_an_hour',
  $agent_version                  = 'installed',
  $ca_server                      = undef,
  $cfacter                        = false,
  $collection                     = undef,
  $custom_facts                   = undef,
  $devel_repo                     = false,
  $enabled                        = true,
  $enable_devel_repo              = false,
  $enable_mechanism               = 'service',
  $enable_repo                    = true,
  $environment                    = 'production',
  $facter_version                 = 'installed',
  $hiera_version                  = 'installed',
  $logdest                        = undef,
  $manage_etc_facter              = true,
  $manage_etc_facter_facts_d      = true,
  $manage_repos                   = true,
  $manage_repo_method             = 'files',
  $preferred_serialization_format = 'pson',
  $puppet_server                  = 'puppet',
  $puppet_version                 = 'installed',
  $reports                        = true,
  $runinterval                    = '30m',
  $splay                          = false,
  $splaylimit                     = undef,
  $structured_facts               = false,
  $use_srv_records                = false,
  $srv_domain                     = undef,
  $pluginsource                   = undef,
  $pluginfactsource               = undef,
) {
  #input validation
  validate_bool(
    $allinone,
    $cfacter,
    $enable_devel_repo,
    $enabled,
    $enable_repo,
    $manage_etc_facter,
    $manage_etc_facter_facts_d,
    $manage_repos,
    $reports,
    $splay,
    $structured_facts,
  )

  validate_string(
    $agent_version,
    $ca_server,
    $collection,
    $environment,
    $facter_version,
    $hiera_version,
    $logdest,
    $manage_repo_method,
    $puppet_server,
    $puppet_version,
    $splaylimit,
    $runinterval,
  )
  $manage_repo_types = ['files','package']
  validate_re($manage_repo_method,$manage_repo_types)

  $serialization_formats = ['pson','msgpack']
  validate_re($preferred_serialization_format,$serialization_formats)

  $supported_mechanisms = ['service', 'cron']
  validate_re($enable_mechanism, $supported_mechanisms)

  include ::puppet::defaults
  $facterbasepath = $::puppet::defaults::facterbasepath

  if $devel_repo == true {
    notify { 'Deprecation notice: puppet::devel_repo is deprecated, use puppet::enable_devel_repo instead': }
  }

  if $enable_mechanism == 'cron' {
    #no point in generating this unless we're using it
    case $agent_cron_min {
      #provide a co
      'two_times_an_hour': {
        $min=fqdn_rand(29) + 0  # fqdn_rand used to return a string prior to 4.0?
        $min_2=$min + 30
        $agent_cron_min_interpolated = [ $min, $min_2 ]
      }
    'four_times_an_hour': {
        $min=fqdn_rand(14) + 0  # fqdn_rand used to return a string prior to 4.0?
        $min_2=$min + 15
        $min_3=$min + 30
        $min_4=$min + 45
        $agent_cron_min_interpolated = [ $min, $min_2, $min_3, $min_4 ]
      }
      default: {
        #the variable is populated. feed that to the cronjob
        $agent_cron_min_interpolated = $agent_cron_min
      }
    }
    #tooling in case we want to provide similar human_readable behaviors to
    #cron_hour
    $agent_cron_hour_interpolated = $agent_cron_hour
  }
  else {
    #ensure our public variables are never unassigned
    $agent_cron_min_interpolated = undef
    $agent_cron_hour_interpolated = undef
  }
  $enable = $enabled ? {
    default => true,
    false   => false,
  }

  if $manage_repos {
    #only manage this if we're managing repos
    include ::puppet::repo
    Class['::puppet::repo'] -> Class['::puppet::install']
  }

  if $allinone {
    $owner_group = 'root'
  }
  else {
    $owner_group = 'puppet'
  }
  if $::puppet::manage_etc_facter {
    file { $facterbasepath:
      ensure => directory,
      owner  => 'root',
      group  => $owner_group,
      mode   => '0755',
    }
  }

  if $::puppet::manage_etc_facter_facts_d {
    file { "${facterbasepath}/facts.d":
      ensure => directory,
      owner  => 'root',
      group  => $owner_group,
      mode   => '0755',
    }
  }

  if $custom_facts {
    class { '::puppet::facts':
      custom_facts => $custom_facts,
    }
  }
  include ::puppet::install
  include ::puppet::config
  include ::puppet::agent

  Class['puppet::install'] ->
  Class['puppet::config'] ~>
  Class['puppet::agent']

}
