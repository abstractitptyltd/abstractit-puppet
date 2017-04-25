# The puppet::profile::agent class is responsible for configuring the puppet agent on a node
#
# @puppet::profile::agent when declaring the puppet::profile::agent class
#   include puppet::profile::agent
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
# @param ca_server [String] Default: undef
#   Server to use as the CA server for all agents.
# @param agent_version [String] Default: 'installed'
#   Declares the version of the puppet-agent all-in-one package to install.
# @param cfacter [Boolean] Default: false
#   Whether or not to use cfacter instead of facter.
# @param collection [String] Default: undef
#   Declares the collection repository to use.
# @param custom_facts [Hash] Default: undef
#   A hash of custom facts to setup using the ::puppet::facts define.
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
# @param show_diff [Boolean] Default: false
#   Sets the show_diff parameter in puppet.conf
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


class puppet::profile::agent (
  $allinone                       = false,
  $agent_cron_hour                = '*',
  $agent_cron_min                 = 'two_times_an_hour',
  $agent_version                  = 'installed',
  $ca_server                      = undef,
  $cfacter                        = false,
  $collection                     = undef,
  $custom_facts                   = undef,
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
  $show_diff                      = false,
  $splay                          = false,
  $splaylimit                     = undef,
  $structured_facts               = false,
) {
  class { '::puppet':
    allinone                       => $allinone,
    agent_cron_hour                => $agent_cron_hour,
    agent_cron_min                 => $agent_cron_min,
    agent_version                  => $agent_version,
    ca_server                      => $ca_server,
    cfacter                        => $cfacter,
    collection                     => $collection,
    custom_facts                   => $custom_facts,
    enabled                        => $enabled,
    enable_devel_repo              => $enable_devel_repo,
    enable_mechanism               => $enable_mechanism,
    enable_repo                    => $enable_repo,
    environment                    => $environment,
    facter_version                 => $facter_version,
    hiera_version                  => $hiera_version,
    logdest                        => $logdest,
    manage_etc_facter              => $manage_etc_facter,
    manage_etc_facter_facts_d      => $manage_etc_facter_facts_d,
    manage_repos                   => $manage_repos,
    manage_repo_method             => $manage_repo_method,
    preferred_serialization_format => $preferred_serialization_format,
    puppet_server                  => $puppet_server,
    puppet_version                 => $puppet_version,
    reports                        => $reports,
    runinterval                    => $runinterval,
    show_diff                      => $show_diff,
    splay                          => $splay,
    splaylimit                     => $splaylimit,
    structured_facts               => $structured_facts,
  }

}
