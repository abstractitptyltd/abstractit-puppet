#abstractit-puppet

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet](#setup)
    * [What puppet affects](#what-puppet-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet](#beginning-with-puppet)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: puppet](#class-puppet)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

Manage puppet master, agents, modules using the same principals as you manage your other services.

##Module Description

This module is very opinionated. It makes a few assumptions on how to manage a puppet master and it's agents.
These opintions are what I consider the best way to do things based on my experiences using puppet.
Those opinions have also been heavily influnced by the likes of Gary Larizza, Zack Smith, Craig Dunn and Adrien Thebo.

If those opionions differ from how you would like this module to work I am happy to accept pull requests.

Right now that that's out of the way here's how it works.
Out of the box it manages the pupetlabs repo, the puppet agent, the versions installed and it's environment.
It can also optionally manage some facts using the facter.d structure (I use these in my hiera setup).
On a puppet master it manages the puppet master, passenger, a few dependencies, their versions, hiera and some basic config.
It can also optionally manage a module environment (or environments) and a hiera repo with r10k and puppetdb.

It's useful because i believe puppet needs to be managed just as much as any other service in your environment.
It may not be the best way to do it but it's how I do it and it works for me.
This module is how I manage puppet for my clients so it gets extensive testing in production and in my vagrant based development environments.
If it works for you thats awesome, if it doesn't let me know or send me a pull request.

##Setup

###What puppet affects

* **Directories:**
  * /var/lib/puppet
* **Files:**  `dynamically updated files are displayed like this`
  *
  * `/etc/puppet/puppet.conf`
* **Cron Jobs**
* **Logs being rotated**
* **Packages: **
  * **RedHat:**
  UNSUPPORTED
  * **Debian:**

* puppet and it's config files, hiera config, apache vhost for puppetmaster.

###Setup Requirements

This module currently only works on Ubuntu Precise at this stage. I will be adding support for other operating systems when I get a chance.
It also only configures puppet 3.6.x. If you need support for previous versions let me know.


#### Module dependencies

  * [apt](git@github.com:puppetlabs/puppetlabs-apt.git)
  * [inifile](git@github.com:puppetlabs/puppetlabs-inifile.git)


###Beginning with puppet

The best way to begin is using the example profiles puppet::profile::agent and puppet::profile::master
These profiles wiill setup agent and master nodes.

##Usage

###Classes and Defined Types

This module modifies Puppet configuration files and directories.
The Class docs are a work in progress. I will detaile my two profile classes initially and add the rest of the classes and defined types as I go.

----

####*Class:* `puppet` [puppetclass]
The main `init.pp` manifest is responsible for validating some of our parameters, and instantiating the [puppet::repo][puppetrepoclass], [pupppet::install][puppetinstallclass], [puppet::config][puppetconfigclass], and [puppet::agent][puppetagentclass] manifests.
#####*Parameters*
  * **devel_repo**: (*bool* Default: `false`)

    Whether or not to enable the puppetlabs_devel apt source.

  * **enabled**: (*bool* Default: `true`)

    Used to determine if services should be running

  * **environment**: (*string* Default: `production`)

    Sets the puppet environment

  * **facter_version**: (*string* Default: `installed`)

    Declares the version of facter to install.

  * **hiera_version**: (*string* Default: `installed`)

    Declares the version of hiera to install.

  * **puppet_server**: (*string* Default: `puppet`)

    The hostname or fqdn of the puppet server that the agent should communicate with.

  * **puppet_version**: (*string* Default: `installed`)

    The version of puppet to install

  * **reports**: (*bool*)

    Whether or not to send reports

  * **runinterval** (*string* Default: `30m`)

    Sets the runinterval in `puppet.conf`

  * **structured_facts**: (*bool* Default: `false`)

    Sets whether or not to enable [structured_facts](http://docs.puppetlabs.com/facter/2.0/fact_overview.html) by setting the [stringify_facts](http://docs.puppetlabs.com/references/3.6.latest/configuration.html#stringifyfacts) variable in puppet.conf.

    **It is important to note that this boolean operates in reverse.** Setting stringify_facts to **false** is required to **permit** structured facts. This is why this parameter does not directly correlate with the configuration key.

----

####Class: **puppet::agent** [puppetagentclass]

----

####Class: **puppet::config** [puppetconfigclass]

----

####Class: **puppet::facts** [puppetfactsclass]

----

####Class: **puppet::install** [puppetinstallclass]

----

####Class: **puppet::master** [puppetmasterclass]

----

####Class: **puppet::repo** [puppetrepoclass]

----

####Class: `puppet::profile::agent`

The puppet module's profile `puppet::profile::agent`, guides the basic setup of a Puppet Agent on your system.

**Parameters within `puppet::profile::agent`:**

#####`enabled`

Whether to enable the puppet agent. Default `true`.

#####`puppet_version`

Version of the puppet agent to install. Default `installed`.

#####`hiera_version`

Version of hiera to install. Default `installed`.

#####`facter_version`

Version of the puppet agent to install. Default `installed`.

#####`puppet_server`

Puppet server the node will recieve it's catalog from. Default `puppet`.

#####`environment`

Environment the agent will use. Default `production`

#####`devel_repo`

Whether to use the devel repo. Default `false`.

#####`reports`

Whether to enable reports for the agent. Default `true`.

#####`structured_facts`

Whether to enable structured_facts for the agent. Default `false`.

#####`custom_facts`

Hash of facts to set on the agent. Default `undef`.

####Class: `puppet::profile::master`

The puppet module's profile `puppet::profile::agent`, guides the basic setup of a Puppet Master on your system.

**Parameters within `puppet::profile::master`:**

#####`hiera_repo`

Repository to use for hiera data. No Default.

#####`hiera_hierarchy`

Array to use as the hiera hierarchy. No Default.

#####`puppet_env_repo`

Repository containing a valid puppet environment. R10K will set this up as your environments. Default `undef`.

#####`extra_env_repos`

Hash of extra repositories to use for R10K environments. Default `undef`.

#####`modules`

Whether to setup module trees with R10K. Default `true`.

#####`puppet_server`

Puppet server to use for this node. Default `puppet`.

#####`puppet_fqdn`

FQDN of the puppet server. Default `$::fqdn`.

#####`puppetdb_server`

FQDN of the puppetdb server. Default `$::fqdn`.

#####`puppetdb_use_ssl`

Whether to use ssl for PuppetDB. Default `true`.

#####`puppetdb_listen_address`

Listen address for PuppetDB. Default `127.0.0.1`.

#####`puppetdb_ssl_listen_address`

SSL listen address for PuppetDB. Default `127.0.0.1`.

#####`puppet_version`

Version of puppet to be installed. This is passsed to a package resource so it needs to be a valid version string for your `$::operatingsystem`. Default `installed`.

#####`puppetdb_version`

Version of puppet to be installed. This is passsed to a package resource so it needs to be a valid version string for your `$::operatingsystem`. Default `installed`.

#####`r10k_version`

Version of the R10K gem to install. Default `installed`.

#####`hiera_eyaml_version`

Version of the hiera_eyaml gem to install. Default `installed`.

#####`pre_module_path`

Module path to add to beginning of `basemodulepath`. Default empty.

#####`module_path`

Module path to use for `basemodulepath`. Default empty.

#####`eyaml_keys`

Whether to manage the keys for hoera-eyaml. Default `false`.

#####`hieradata_path`

Base directory to use for the hiera data directory. R10K will check out each branch from the repostory as an environment. Default `/etc/puppet/hiera`.

#####`hiera_backends`

Hash of bachend settinga for hiera. Default base setup for yaml.

#####`env_owner`

System user that will own the R10K environment and run the crons. Default `puppet`.

#####`future_parser`

Whether to enable the future parser. Default `false`.

#####`environmentpath`

Directory to use for the `environmentpath`. Default `/etc/puppet/environments`.

#####`autosign`

Whether to setup puppet to autosign certificates. Default `false`.

#####`reports`

Whether to enable reports for this node. Default `true`.

#####`node_ttl`

TTL for nodes in PuppetDB. Default `0s` (unlimited).

#####`node_purge_ttl`

TTL to purge nodes in PuppetDB. Default `0s` (unlimited).

#####`report_ttl`

TTL for reports in PuppetDB. Default `14d`.

#####`r10k_purgedirs`

Whether r10k should purge old modules. Default `true`.

#####`r10k_env_basedir`

Base directory to use for R10K environments. Default `/etc/puppet/r10kenv`.

#####`r10k_update`

Whether to enable the cron to run R10K to deploy the production environment. Default `true`.

#####`r10k_minutes`

Minutes to run the R10K cron. Default `0,`5,30,45`

#####`puppetdb`

Whether to setup PuppetDB. Default `true`.

#####`passenger_max_pool_size`

Max Pool Size for passenger. Default `12`.

#####`passenger_pool_idle_time`

Pool Idle Time for passenger. Default `1500`.

#####`passenger_stat_throttle_rate`

Stat Throttle Rate for Passenger. Default `120`.

#####`passenger_max_requests`

Max Requests for Passenger. Default `0` (unlimited).


##Limitations

Currently the only tested operating system is Ubuntu with puppet 3.6.x.
Other operating systems and puppet versions will be added when I get the time to test them.

##Development

All development and testing is done by me (rendhalver) for Abstract IT and it's clients.
Pull requests are welcome.

##Release Notes/Contributors/Etc

Check the CHANGELOG.md for release notes and bug fixes.
It's a bit sparse right now and only contains the public releases.
