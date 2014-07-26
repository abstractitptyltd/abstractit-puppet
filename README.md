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
  * /etc/facter
  * /etc/facter/facts.d
  * /etc/puppet/keys
  * /etc/puppet/keys/eyaml
* **Files:**  `dynamically updated files are displayed like this`
  * `/etc/hiera.yaml`
  * `/etc/puppet/puppet.conf`
  * `/etc/puppet/hiera.yaml`
  * `/etc/r10k.yaml`
  * /etc/puppet/keys/eyaml/private_key.pkcs7.pem
  * /etc/puppet/keys/eyaml/public_key.pkcs7.pem
* **Cron Jobs**
* **Logs being rotated**
* **Packages:**
    * **Debian:**
        * puppet
        * puppet-common
        * hiera
        * facter
    * **RedHat:**
    CURRENTLY UNSUPPORTED
* puppet and it's config files, hiera config, apache vhost for puppetmaster.

###Setup Requirements

This module currently only works on Ubuntu Precise at this stage. I will be adding support for other operating systems when I get a chance.
It also only configures puppet 3.6.x. If you need support for previous versions let me know.


#### Module dependencies

  * [apt](https://github.com/puppetlabs/puppetlabs-apt)
  * [concat](https://github.com/puppetlabs/puppetlabs-concat) (master only)
  * [inifile](https://github.com/puppetlabs/puppetlabs-inifile)
  * [apache](https://github.com/puppetlabs/puppetlabs-apache) (master only)
  * [postgres](https://github.com/puppetlabs/puppetlabs-postgresql) (when using the puppetdb subclass)
  * [puppetdb](https://github.com/puppetlabs/puppetlabs-puppetdb) (when using the puppetdb subclass)

###Beginning with puppet

The best way to begin is using the example profiles puppet::profile::agent and puppet::profile::master
These profiles wiill setup agent and master nodes.

##Usage

###Classes and Defined Types

This module modifies Puppet configuration files and directories.
The Class docs are a work in progress. I will detaile my two profile classes initially and add the rest of the classes and defined types as I go.

----

####[Public] *Class:* `puppet`
#####*Description*
The main `init.pp` manifest is responsible for validating some of our parameters, and instantiating the [puppet::facts](#private-class-puppetfacts), [puppet::repo](#private-class-puppetrepo), [pupppet::install](#private-class-puppetinstall), [puppet::config](#private-class-puppetconfig), and [puppet::agent](#public-class-puppetagent) manifests.
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

  * **manage_etc_facter** (*bool* Default: `true`)

    Whether or not this module should manage the `/etc/facter` directory

  * **manage_etc_facter_facts_d** (*bool* Default: `true`)

    Whether or not this module should manage the `/etc/facter/facts.d` directory

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

####[Public] Class: **puppet::agent**
#####*Description*
The `agent.pp` manifest is responsible for the enablement of the agent service.
#####*Parameters*
  * **enable**: (*string?* Default: `running`)

  Sets the enable parameter value of the puppet service

  * **ensure** (*bool?* Default: `true`)

  Sets the ensure parameter of the puppet service

----

####[Private] Class: **puppet::config**
#####*Description*
The `config.pp` manifest is responsible for altering the configuration of `/etc/puppet/puppet.conf`. This is done via params which call [ini_file](https://github.com/puppetlabs/puppetlabs-inifile) resources to alter the related settings.

#####*Parameters*
  * **puppet_server**: (*string* Default: `puppet`)

    The hostname or fqdn of the puppet server we should connect to.

  * **environment** (*string* Default: `production`)

    The puppet environment the node in question should be set to use.

  * **runinterval** (*string* Default: `30m`)

    Dictates the value of the runinterval setting in puppet.conf.

  * **structured_facts** ( *bool* Default: `false`)

    Sets whether or not to enable [structured_facts](http://docs.puppetlabs.com/facter/2.0/fact_overview.html) by setting the [stringify_facts](http://docs.puppetlabs.com/references/3.6.latest/configuration.html#stringifyfacts) variable in puppet.conf.

    **It is important to note that this boolean operates in reverse.** Setting stringify_facts to **false** is required to **permit** structured facts. This is why this parameter does not directly correlate with the configuration key.

----

####[Public] Defined Type: **puppet::fact**
#####*Description*

  This defined type provides a mechanism to lay down fact files in `/etc/facter/facts.d/`
  The title of the declared resource will dictate the name of the `factname.yaml` file laid down, as well as the keyname, and thus, the fact name.

#####*Parameters*
  * **ensure** (*string* Default: `present`)

  Sets the ensure parameter's value on the file resource laid down.

  * **value** (*string* **No Default**)

  Sets the value of the specified custom fact.

----

####[Private] Class: **puppet::facts**
#####*Description*

  The `facts.pp` manifest is responsible for ensuring that `/etc/facter` and `/etc/facter/facts.d` are present on the local system. It is additionally responsible for populating `/etc/facter/facts.d/local.yaml` with the Key/Value pairs declared in `puppet::facts::custom_facts`

#####*Parameters*
  * **custom_facts** (*hash* Default: `undef`)

  This is a hash of custom facts. For each element in the hash, the key will be the fact name, and the value will, unsurprisingly, be the fact's value.

----

####[Private] Class: **puppet::install**

#####*Description*

  the `install.pp` manifest is responsible for the puppet agent, hiera, and facter packages.

#####*Parameters*
  * **facter_version** (*string* Default: `installed`)

  The version of facter to install

  * **hiera_version** (*string* Defaults: `installed`)

  The version of hiera to install

  * **puppet_version** (*string* Default: `installed`)

  The version of puppet to install

----


####[Public] Class: **puppet::master**

#####*Description*

  The `master.pp` manifest is responsible for performing some input validation, and subsequently configuring a puppetmaster. This is done internally via the  [puppet::master::config](#private-class-puppetmasterconfig), [puppet::master::hiera](#private-class-puppetmasterhiera), [pupppet::master::install](#private-class-puppetmasterinstall), and [puppet::master::passenger](#private-class-puppetmasterpassenger) manifests.

  * Puppetdb may be configured via the [puppet::master::puppetdb](#public-class-puppetmasterpuppetdb) class

  * r10k may be configured via the [puppet::master::modules](#public-class-puppetmastermodules) class

#####*Parameters*
  * **autosign** (*bool* Default: `false`)

  Whether or not to enable autosign.

  * **env_owner** (*string* Default: `puppet`)

  The user which should own hieradata and r10k repos

  * **environmentpath** (*absolute path* Default: `/etc/puppet/environments`)

  The base directory path to have environments checked out into.

  * **eyaml_keys** (*bool* Default: `false`)

  Toggle whether or not to deploy [eyaml](https://github.com/TomPoulton/hiera-eyaml) keys


  * **future_parser** (*bool* Default: `false`)
  Toggle to dictate whether or not to enable the [future parser](http://docs.puppetlabs.com/puppet/latest/reference/experiments_future.html)

  * **hiera_backends** (*hash* Default: `{'yaml' => { 'datadir' => '/etc/puppet/hiera/%{environment}',} }`)

  The backends to configure hiera to query.

  * **hiera_eyaml_version** (*string* Default: `installed`)

  The version of the hiera-eyaml package to install. *It is important to note that the hiera-eyaml package will be installed via gem*

  * **hiera_hierarchy** (*array* Default: `['node/%{::clientcert}', 'env/%{::environment}', 'global']`)

  The hierarchy to configure hiera to use

  * **hieradata_path** (*absolute path* Default: `/etc/puppet/hiera`)

  The location to configure hiera to look for the hierarchy. This also impacts the [puppet::master::modules](#public-class-puppetmastermodules) module's deployment of your r10k hiera repo.

  * **module_path** (*string* Default: '')

  If this is set, it will be used to populate the basemodulepath parameter in `/etc/puppet/puppet.conf`. This does not impact [environment.conf](http://docs.puppetlabs.com/puppet/latest/reference/config_file_environment.html), which should live in your [r10k](https://github.com/adrienthebo/r10k) environment repo.

  * **passenger_max_pool_size** (*string* Default: `12`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [max pool size](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerMaxPoolSize).

  * **passenger_max_requests** (*string* Default: `0`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [max requests](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerMaxRequests).

  * **passenger_pool_idle_time** (*string* Default: `1500`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [pool idle time](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerPoolIdleTime)

  * **passenger_stat_throttle_rate** (*string* Default: `120`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [stat throttle rate](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#_passengerstatthrottlerate_lt_integer_gt)

  * **pre_module_path** (*string* Default: '')

  If set, this is prepended to the modulepath parameter *if it is set* and to a static modulepath list if modulepath is unspecified. *A colon separator will be appended to the end of this if needed*

  * **puppet_fqdn** (*string* Default: `$::fqdn`)

  Sets the namevar of the [apache::vhost](https://github.com/puppetlabs/puppetlabs-apache#defined-type-apachevhost) resource declared. It is also used to derive the `ssl_cert` and `ssl_key` parameters to the apache::vhost resource.

  * **puppet_server** (*string* Default: `$puppet::params::puppet_server`)

  Changing this does not appear to do anything.

  * **puppet_version** (*string* Default: `installed`)

  Specifies the version of the puppetmaster package to install

  * **r10k_version** (*string* Default: `installed`)

  Specifies the version of r10k to install. *It is important to note that the r10k package will be installed via gem*

----

####[Private] Class: **puppet::master::config**
#####*Description*
  The `master/config.pp` manifest is responsible for managing the master-specific configuration settings of `puppet.conf`
#####*Parameters*

  * **environmentpath** (*absolute path* Default: `/etc/puppet/environments`)

  The base directory path to have environments checked out into.

  * **extra_module_path** (*string* Default: `${::settings::confdir}/site:/usr/share/puppet/modules`)

  The derived value for the `basemodulepath` setting.

  * **future_parser** (*bool* Default: `false`)

  Toggle to dictate whether or not to enable the [future parser](http://docs.puppetlabs.com/puppet/latest/reference/experiments_future.html)

  * **autosign** (*bool* Default: `false`)

  Whether or not to enable autosign. *It is important to note that this autosign is currently hard coded to disabled in the production environment*

----

####[Private] Class: **puppet::master::hiera**
#####*Description*

  The `master/hiera.pp` manifest is responsible for configuring hiera, optionally deploying eyaml encryption keys, and setting the ownership of the hieradata path.

#####*Parameters*

  * **env_owner** (*string* Default: `puppet`)

  The user which should own hieradata and r10k repos

  * **eyaml_keys** (*bool* Default: `false`)

  Toggle whether or not to deploy [eyaml](https://github.com/TomPoulton/hiera-eyaml) keys

  * **hiera_backends** (*hash* Default: `{'yaml' => { 'datadir' => '/etc/puppet/hiera/%{environment}',} }`)

  The backends to configure hiera to query.

  * **hieradata_path** (*absolute path* Default: `/etc/puppet/hiera`)

  * **hierarchy** (*array* Default: `['node/%{::clientcert}', 'env/%{::environment}', 'global']`)

----

####[Private] Class: **puppet::master::install**

#####*Description*

  The `master::install.pp` manifest is responsible for installing the packages required to configure a puppetmaster.

#####*Parameters*

  * **puppet_version** (*string* Default: `installed`)

  Specifies the version of the **puppetmaster**, **puppetmaster-common**, and **puppetmaster-passenger** packages to install.

  * **r10k_version** (*string* Default: `installed`)

  Specifies the version of **r10k** to install.

  * **hiera_eyaml_version** (*string* Default: `installed`)

  Specifies the version of **hiera-eyaml** to install

----

####[Public] Class: **puppet::master::modules**

#####*Description*

  The `master::modules.pp` manifest configures [r10k](https://github.com/adrienthebo/r10k) and adds a cronjob to run r10k on a frequency of your choosing.

#####*Parameters*

  * **env_owner** (*string* Default: `puppet`)

  The user which should own the directories on the master.

  * **extra_env_repos** (*hash* Default: `undef`)

  a hash of extra environment repos to pull down. These should be written with the modulename as the key, and the repo URI as the value to a `repo` subkey. The repos will be laid down inside the directory dictated by the `r10k_env_basedirs` param.

  * **hiera_repo** (*string* Default: `undef`)

  the URI of the hiera repo r10k should clone. This also uses the `hieradata_path` parameter set in [puppet::master](#public-class-puppetmaster) to set the hiera source.

  * **puppet_env_repo** (*string* Default: `undef`)

  The URI of your r10k puppet environments repo. **It is important to note that the basedir for this repo is hardcoded to `/etc/puppet/environments`**

  * **r10k_env_basedir** (*absolute path* Default: `/etc/puppet/r10kenv`)

  The base directory to check out extra r10k repos into.

  * **r10k_minutes** (*string or array* Default: `[0, 15, 30, 45]`)

  This param is fed to the [cron](http://docs.puppetlabs.com/references/latest/type.html#cron) resource as the minute parameter. It can be a string, or an array.

  * **r10k_purgedirs** (*bool* Default: `true`)

  Whether or not to tell r10k to purge the directories it checks files out into

  * **r10k_update** (*bool* Default: `true`)

  Whether or not the r10k cronjob should be present.

----

####[Private] Class: **puppet::master::passenger**

#####*Description*

  The `master/passenger.pp` manifest is responsible for instantiating the apache class, creating the apache vhost, and configuring passenger.

  On Trusty, We need to be able to set SSLCARevocationCheck in apache 2.4+ to enable revocation checks for client certs. According to the [Official puppetlabs docs on passenger](http://docs.puppetlabs.com/guides/passenger.html):
    Apache 2.4 introduces the SSLCARevocationCheck directive and sets it to none
    which effectively disables CRL checking. If you are using Apache 2.4+ you must specify 'SSLCARevocationCheck chain' to actually use the CRL.

#####*Parameters*

  * **passenger_max_pool_size** (*string* Default: `12`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [max pool size](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerMaxPoolSize).

  * **passenger_max_requests** (*string* Default: `0`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [max requests](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerMaxRequests).

  * **passenger_pool_idle_time** (*string* Default: `1500`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [pool idle time](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerPoolIdleTime)

  * **passenger_stat_throttle_rate** (*string* Default: `120`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [stat throttle rate](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#_passengerstatthrottlerate_lt_integer_gt)

 * **puppet_fqdn** (*string* Default: `$::fqdn`)

  Sets the namevar of the [apache::vhost](https://github.com/puppetlabs/puppetlabs-apache#defined-type-apachevhost) resource declared. It is also used to derive the `ssl_cert` and `ssl_key` parameters to the apache::vhost resource.

----

####[Public] Class: **puppet::master::puppetdb**

#####*Description*

  The `master/puppetdb.pp` manifest properly instantiates the puppetdb module, so that puppetdb gets set up.

#####*Parameters*

  * **puppetdb_version** (** Default: ``)

  The version of puppetdb to install.

  * **node_purge_ttl (*string* Default: `0s`)

  The length of time a node can be deactivated before it's deleted from the database. (a value of '0' disables purging).

  * **node_ttl** (*string* Default: `0s`)

  The length of time a node can go without receiving any new data before it's automatically deactivated. (defaults to '0', which disables auto-deactivation).

  * **puppetdb_listen_address** (*string* Default: `127.0.0.1`)

  The address that the web server should bind to for HTTP requests. Set to '0.0.0.0' to listen on all addresses.

  * **puppetdb_server** (*string* Default: `puppet.${::domain}`)

  The dns name or ip of the puppetdb server.

  * **puppetdb_ssl_listen_address** (*string* Default: `127.0.0.1`)

  The address that the web server should bind to for HTTPS requests. Set to '0.0.0.0' to listen on all addresses.

  * **report_ttl** (*string* Default: `14d`)

  The length of time reports should be stored before being deleted. (defaults to 14 days).

  * **reports**  (*bool* Default: `true`)

  A toggle to alter the behavior of reports and puppetdb.
  If true, the module will properly set the 'reports' field in the puppet.conf file to enable the puppetdb report processor.

  * **use_ssl** (*bool* Defaults: `true`)

  A toggle to enable or disable ssl on puppetdb connections.


----

####[Private] Class: **puppet::repo**

#####*Description*

This module is responsible for optionally managing the presence of the puppetlabs package repositories.

#####*Parameters*

 * **devel_repo** (*bool* `false`)
  A toggle to manage the ensure parameter value of the puppetlabs_devel repository

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

Minutes to run the R10K cron. Default `0,5,30,45`

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
