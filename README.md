#abstractit-puppet

[![Build Status](https://travis-ci.org/abstractitptyltd/abstractit-puppet.svg?style=plastic)](https://travis-ci.org/abstractitptyltd/abstractit-puppet)
[![Puppet Forge](https://img.shields.io/puppetforge/v/abstractit/puppet.svg?style=plastic)](https://forge.puppetlabs.com/abstractit/puppet)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/abstractit/puppet.svg?style=plastic)](https://forge.puppetlabs.com/abstractit/puppet)
[![Puppet Forge Modules](https://img.shields.io/puppetforge/mc/abstractit.svg?style=plastic)](https://forge.puppetlabs.com/abstractit)


####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet](#setup)
    * [What puppet affects](#what-puppet-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet](#beginning-with-puppet)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: puppet](#class-puppet)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors](#contributors)
8. [Release Notes/Etc]#release

##Overview

Manage puppet master, agents, modules using the same principals as you manage your other services.

##Module Description

This module is very opinionated. It makes a few assumptions on how to manage a puppet master and it's agents.
These opinions are what I consider the best way to do things based on my experiences using puppet.
Those opinions have also been heavily influenced by the likes of Gary Larizza, Zack Smith, Craig Dunn and Adrien Thebo.

If you would like this module to behave differently I am happy to accept pull requests. Please maintain backwards compatibility wherever prudent.

Right now that that's out of the way here's how it works.
Out of the box it manages the pupetlabs repo, the puppet agent, the versions installed and it's environment.
It can also optionally manage some facts using the facter.d structure (I use these in my hiera setup).
On a puppet master it manages the puppet master, passenger, a few dependencies, their versions, hiera and some basic config.
It can also optionally manage a module environment (or environments) and a hiera repo with r10k and puppetdb.

I believe Puppet needs to be managed just as explicitly as any other service in your environment.
It may not be the best way to do it but it's how I do it and it works for me.
This module is how I manage puppet for my clients so it gets extensive testing in production and in my vagrant based development environments.
If it works for you, awesome! If not, let me know *or send me a pull request*.

##Setup

###What puppet affects

* **Directories:**
  * Puppet 3.x
    * /etc/facter
    * /etc/facter/facts.d
    * /etc/puppet/hiera_eyaml_keys
  * Puppet 4.x
    * /etc/puppetlabs/code/environments/**
    * /etc/puppetlabs/code/hieradata/**
    * /etc/puppetlabs/code/hiera_eyaml_keys
* **Files:**  `dynamically updated files are displayed like this`
  * **Debian**
    * `/etc/default/puppet`
  * **RedHat**
    * `/etc/sysconfig/puppet`
  * Puppet 3.x
    * `/etc/hiera.yaml`
    * `/etc/puppet/puppet.conf`
    * `/etc/puppet/hiera.yaml`
    * `/etc/r10k.yaml`
    * /etc/puppet/hiera_eyaml_keys/private_key.pkcs7.pem
    * /etc/puppet/hiera_eyaml_keys/public_key.pkcs7.pem
  * Puppet 4.x
    * `/etc/puppetlabs/code/hiera.yaml`
    * `/etc/puppetlabs/puppet/puppet.conf`
    * `/etc/r10k.yaml`
    * /etc/puppetlabs/code/hiera_eyaml_keys/private_key.pkcs7.pem
    * /etc/puppetlabs/code/hiera_eyaml_keys/public_key.pkcs7.pem
* **Cron Jobs**
  * *puppet_r10k* `puppet::profile::r10k`
  * *puppet clean reports* `puppet::profile::puppetdb`
  * *run_puppet_agent* `puppet::agent`
* **Logs being rotated**
* **Packages:**
  * r10k `puppet::profile::r10k`
  * puppetdb `puppet::profile::puppetdb`
  * Puppet 4.x
    * puppet-agent
    * puppetserver
  * Puppet 3.x
    * **Debian:**
      * facter
      * hiera
      * hiera-eyaml `puppet::master::install`
      * puppet
      * puppet-common
      * puppetlabs-release
      * puppetmaster-common `puppet::master::install::deps`
    * **RedHat:**
      * facter
      * hiera
      * puppet
      * puppetlabs-release
      * MASTER CURRENTLY UNSUPPORTED UNDER Puppet 3
* puppet and it's config files, hiera config, apache vhost for puppetmaster.

###Setup Requirements

This module currently only works completely on Ubuntu Precise and Trusty.
Support for RedHat and CentOS 5,6 and 7 has been added for the new Collections and Puppet 4.x.
The new puppet-agent and puppetserver are supported on Ubuntu, Centos and RedHat but a puppet master running under Passenger is only supported on Ubuntu.

I will be adding support for other operating systems when I get a chance.
It also only configures puppet 3.6.x and 4.x If you need support for previous versions let me know.


#### Forge Module dependencies

  * [puppetlabs-apt](https://forge.puppetlabs.com/puppetlabs/apt)
  * [puppetlabs-concat](https://forge.puppetlabs.com/puppetlabs/concat) (master only)
  * [puppetlabs-stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
  * [puppetlabs-inifile](https://forge.puppetlabs.com/puppetlabs/inifile)
  * [puppetlabs-apache](https://forge.puppetlabs.com/puppetlabs/apache) (master only when using a passenger setup)
  * [puppetlabs-postgresql](https://forge.puppetlabs.com/puppetlabs/postgresql) (when using the puppetdb profile)
  * [puppetlabs-puppetdb](https://forge.puppetlabs.com/puppetlabs/puppetdb) (when using the puppetdb profile)
  * [puppet-puppetboard](https://forge.puppetlabs.com/puppet/puppetboard) (when using the puppetboard profile)
  * [zack-r10k](https://forge.puppetlabs.com/zack/r10k) (when using the r10k profile)
  * [puppetlabs-puppetserver_gem](https://forge.puppetlabs.com/puppetlabs/puppetserver_gem) (when managing the hiera-eyaml and/or deep_merge gem on puppet 4.x)

###Beginning with puppet

The best way to begin is using the example profiles puppet::profile::agent and puppet::profile::master
These profiles will setup agent and master nodes.
I also have profiles for setting up R10K, puppetdb and puppetboard.

##Usage

All interactions with puppet in done via the base classes `puppet` and `puppet::master` or the profiles
I generally include the agent profile on all nodes and use hiera to setup the data.
I have included some basic examples for setting up common settings on the agent or master.

###Basic setup of an agent

    include '::puppet'
or
    include '::puppet::profile::agent'

### Setup custom facts on an agent

    class { '::puppet::profile::agent':
      custom_facts => {
        'data_centre' => 'office',
        'role'        => 'webserver',
      }
    }

### Set a ca_server for your environment

    class { '::puppet::profile::agent':
      ca_server => 'puppetca.domain.com'
    }

### Enable cfacter

    class { '::puppet::profile::agent':
      cfacter => true
    }

### Use packages for repository management

    class { '::puppet::profile::agent':
      manage_repo_method => 'package'
    }

### Disable repository management

    class { '::puppet::profile::agent':
      manage_repos => false
    }

### Set allinone and puppet collection use on your infrastructure

    class { '::puppet::profile::agent':
      allinone   => true,
      collection => 'PS1'
    }

### Set environment for the agent

    class { '::puppet::profile::agent':
      environment => 'testenv'
    }

### Set use the new msgpack serialization format on an agent

    class { '::puppet::profile::agent':
      preferred_serialization_format => 'msgpack'
    }

###Basic setup of a puppet master

    include '::puppet'
    include '::puppet::master'
or
    include '::puppet::profile::agent'
    include '::puppet::profile::master'
    include '::puppet::profile::puppetdb'
    include '::puppet::profile::puppetboard'
    include '::puppet::profile::r10k'

to setup a master with all the features


### Set basemodulepath for the master

    class { '::puppet::profile::master':
      basemodulepath => '/opt/puppet_code/modules:/etc/puppet/modules'
    }

### Set ram for new puppet server on the master

    class { '::puppet::profile::master':
      java_ram => '1532'
    }

### Set ram for new puppet server on the master

    class { '::puppet::profile::master':
      java_ram => '1532M'
    }

### Setup basic autosigning

    class { '::puppet::profile::master':
      autosign_method => 'file',
      autosign_domains => ['*.sub1.domain.com','*.sub2.domain.com'],
    }


##Reference

###Classes and Defined Types

In the near future I will be moving these docs into each class into a format suitable for to [puppet-strings](https://forge.puppetlabs.com/puppetlabs/strings).
----

####[Public] *Class:* `puppet`
#####*Description*
The `puppet` class is responsible for validating some of our parameters, and instantiating the [puppet::facts](#private-class-puppetfacts), [puppet::repo](#private-class-puppetrepo), [pupppet::install](#private-class-puppetinstall), [puppet::config](#private-class-puppetconfig), and [puppet::agent](#public-class-puppetagent) manifests.
#####*Parameters*

  * **allinone**: (*string* Default: `false`)

    Whether to use the new collections

  * **agent_cron_hour**: (*string* Default: `undef`)

    The hour to run the agent cron. Valid values are `0-23`

  * **agent_cron_min**: (*string*/*array* Default: `two_times_an_hour`)

  This param accepts any value accepted by the [cron native type](http://docs.puppetlabs.com/references/latest/type.html#cron-attribute-minute), as well as two special options: `two_times_an_hour`, and `four_times_an_hour`. These specials use [fqdn_rand](http://docs.puppetlabs.com/references/latest/function.html#fqdnrand) to generate a random minute array on the selected interval. This should distribute the load more evenly on your puppetmasters.

  * **agent_custom_cron_command**: (*string* Default: `undef`)

    Optional custom puppet agent cron command

  * **agent_version**: (*string* Default: `installed`)

    Declares the version of the puppet-agent all-in-one package to install.

  * **ca_server**: (*string* Default: `undef`)

    Server to use as the CA server for all agents.

  * **cfacter**: (*bool* Default: `false`)

    Whether or not to use cfacter instead of facter.

  * **collection**: (*string* Default: `undef`)

    Declares the collection repository to use.

  * **custom_facts**: (*hash* Default: `undef`)

    A hash of custom facts to setup using the ::puppet::facts define.

  * **enabled**: (*bool* Default: `true`)

    Used to determine if the puppet agent should be running

  * **enable_devel_repo**: (*bool* Default: `false`)

    This param will replace `devel_repo` in 2.x. It conveys to [puppet::repo::apt](#private-class-puppetrepoapt) whether or not to add the devel apt repo source.
    When `devel_repo` is false, `enable_devel_repo` is consulted for enablement. This gives `devel_repo` backwards compatibility at the cost of some confusion if you set `devel_repo` to true, and `enable_devel_repo` to false.

  * **enable_repo**: (*bool* Default `true`)

    if `manage_repos` is true, this determines whether or not the puppetlabs' repository should be present. *This is not consulted in any way if `manage_repos` is false*

  * **enable_mechanism**: (*string* Default: `service`)

    A toggle which permits the option of running puppet as a service, or as a cron job.

  * **environment**: (*string* Default: `production`)

    Sets the puppet environment

  * **facter_version**: (*string* Default: `installed`)

    Declares the version of facter to install.

  * **hiera_version**: (*string* Default: `installed`)

    Declares the version of hiera to install.

  * **logdest**: (*string* Default: `undef`)

    File to use a log file for agent.

  * **manage_etc_facter** (*bool* Default: `true`)

    Whether or not this module should manage the `/etc/facter` directory

  * **manage_etc_facter_facts_d** (*bool* Default: `true`)

    Whether or not this module should manage the `/etc/facter/facts.d` directory

  * **manage_repos**: (*bool* Default `true`)

    Whether or not we pay any attention to managing repositories. This is managed by only including [puppet::repo](#private-class-puppetrepo) subclass when true. The individual repo subclasses also will perform no action if included with this param set to false.

  * **manage_repo_method**: (*string* Default `files`)

    Sets the method for managing the repo files

  * **preferred_serialization_format**: (*string* Default: `pson`)

    The serialization format to use for communication with the puppet server.communicate with.
    WARNING: Setting this to msgpack is experimental! Please enable with care.

  * **puppet_server**: (*string* Default: `puppet`)

    The hostname or fqdn of the puppet server that the agent should communicate with.

  * **puppet_version**: (*string* Default: `installed`)

    The version of puppet to install

  * **reports**: (*bool*)

    Whether or not to send reports

  * **runinterval**: (*string* Default: `30m`)

    Sets the runinterval in `puppet.conf`

  * **structured_facts**: (*bool* Default: `false`)

    Sets whether or not to enable [structured_facts](http://docs.puppetlabs.com/facter/2.0/fact_overview.html) by setting the [stringify_facts](http://docs.puppetlabs.com/references/3.6.latest/configuration.html#stringifyfacts) variable in puppet.conf.

    **It is important to note that this boolean operates in reverse.** Setting stringify_facts to **false** is required to **permit** structured facts. This is why this parameter does not directly correlate with the configuration key.

----

####[Private] Class: **puppet::agent**
#####*Description*
The `puppet::agent` class is responsible for management of the of the agent service, and agent cronjob. depending on the

#####*Parameters*
  * None

----

####[Private] Class: **puppet::config**
#####*Description*
The `puppet::config` class is responsible for altering the configuration of `$confdir/puppet.conf`. This is done via params which call [ini_file](https://forge.puppetlabs.com/puppetlabs/inifile) resources to alter the related settings.

#####*Parameters*

 * None

----

####[Public] Defined Type: **puppet::fact**
#####*Description*

  This defined type provides a mechanism to lay down fact files in `/etc/facter/facts.d/`
  The title of the declared resource will dictate the name of the `factname.yaml` file laid down, as well as the keyname, and thus, the fact name.

#####*Parameters*

  * **ensure**: (*string* Default: `present`)

  Sets the ensure parameter's value on the file resource laid down.

  * **value**: (*string* **No Default**)

  Sets the value of the specified custom fact.

----

####[Private] Class: **puppet::facts**
#####*Description*

  The `puppet::facts` class is responsible for ensuring that `/etc/facter` and `/etc/facter/facts.d` are present on the local system. It is additionally responsible for populating `/etc/facter/facts.d/local.yaml` with the Key/Value pairs declared in `puppet::facts::custom_facts`

#####*Parameters*
  * **custom_facts**: (*hash* Default: `undef`)

  This is a hash of custom facts. For each element in the hash, the key will be the fact name, and the value will, unsurprisingly, be the fact's value.

----

####[Private] Class: **puppet::install**

#####*Description*

  the `puppet::install` class is responsible for the puppet agent, hiera, and facter packages.

#####*Parameters*

 * None

----


####[Public] Class: **puppet::master**

#####*Description*

  The `puppet::master` class is responsible for performing some input validation, and subsequently configuring a puppetmaster. This is done internally via the  [puppet::master::config](#private-class-puppetmasterconfig), [puppet::master::hiera](#private-class-puppetmasterhiera), [pupppet::master::install](#private-class-puppetmasterinstall), and [puppet::master::passenger](#private-class-puppetmasterpassenger) manifests.

  * Puppetdb may be configured via the [puppet::profile::puppetdb](#public-class-puppetmasterpuppetdb) class

  * r10k may be configured via the [puppet::profile::r10k](#public-class-puppetmastermodules) class

#####*Parameters*
  * **autosign**: (*bool* Default: `false`)

  Whether or not to enable autosign.

  * **autosign_domains**: (*array* Default: `empty`)

  Array of domains to use for basic autosigning

  * **autosign_file**: (*string* Default: `$confdir/autosign.conf`)

  File to use for basic autosigning

  * **autosign_method**: (*string* Default: `file`)

  Method to use for autosign
  The default 'file' will use the $confdir/autosign.conf file to determine which certs to sign.
  This file is empty by default so autosigning will be effectively off
  'on' will set the autosign variable to true and thus all certs will be signed.
  'off' will set the autosign variable to false disabling autosign completely.

  * **basemodulepath**: (*absolute path* Default Puppet 4: `${codedir}/environments` Default Puppet 3: `/etc/puppet/environments`)

  The base directory path to have environments checked out into.

  * **deep_merge_version**: (*string* Default: `installed`)

  The version of the deep_merge package to install.

  * **env_owner**: (*string* Default: `puppet`)

  The user which should own hieradata and r10k repos

  * **environmentpath**: (*absolute path* Default Puppet 4: `${codedir}/modules:${confdir}/modules` Default Puppet 3: `${confdir}/modules:/usr/share/puppet/modules`)

  The base directory path to have environments checked out into.

  * **eyaml_keys**: (*bool* Default: `false`)

  Toggle whether or not to deploy [eyaml](https://github.com/TomPoulton/hiera-eyaml) keys


  * **future_parser**: (*bool* Default: `false`)
  Toggle to dictate whether or not to enable the [future parser](http://docs.puppetlabs.com/puppet/latest/reference/experiments_future.html)

  * **hiera_backends**: (*hash* Default Puppet 3: `{'yaml' => { 'datadir' => '/etc/puppet/hiera/%{environment}',} }` Default Puppet 4: `{'yaml' => { 'datadir' => '$codedir/hieradata/%{environment}',} }`)

  The backends to configure hiera to query.

  * **hiera_eyaml_version**: (*string* Default: `installed`)

  The version of the hiera-eyaml package to install. *It is important to note that the hiera-eyaml package will be installed via gem*

  * **hiera_hierarchy**: (*array* Default: `['node/%{::clientcert}', 'env/%{::environment}', 'global']`)

  The hierarchy to configure hiera to use

  * **hiera_merge_behavior**: (*string* Default: `undef`)

  The type of [merge behaviour](http://docs.puppetlabs.com/hiera/latest/configuring.html#mergebehavior) that should be used by hiera. Defaults to not being set.

  * **hieradata_path**: (*absolute path* Default Puppet 3: `/etc/puppet/hiera` Default Puppet 4: `$codedir/hieradata`)

  The location to configure hiera to look for the hierarchy. This also impacts the [puppet::master::modules](#public-class-puppetmastermodules) module's deployment of your r10k hiera repo.

  * **java_ram**: (*string* Default: `2g`)

  Set the ram to use for the new puppetserver

  * **manage_deep_merge_package**: (*bool* Default: `false`)

  Whether the [deep_merge gem](https://rubygems.org/gems/deep_merge) should be installed.

  * **manage_hiera_eyaml_package**: (*bool* Default: `true`)

  Whether the [hiera-eyaml gem](https://rubygems.org/gems/hiera-eyaml) should be installed.

  * **passenger_max_pool_size**: (*string* Default: `12`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [max pool size](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerMaxPoolSize).

  * **passenger_max_requests**: (*string* Default: `0`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [max requests](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerMaxRequests).

  * **passenger_pool_idle_time**: (*string* Default: `1500`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [pool idle time](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#PassengerPoolIdleTime)

  * **passenger_stat_throttle_rate**: (*string* Default: `120`)

  Adjusts the [apache::mod::passenger](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/mod/passenger.pp) configuration to configure the specified [stat throttle rate](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#_passengerstatthrottlerate_lt_integer_gt)

  * **puppet_fqdn**: (*string* Default: `$::fqdn`)

  Sets the namevar of the [apache::vhost](https://github.com/puppetlabs/puppetlabs-apache#defined-type-apachevhost) resource declared. It is also used to derive the `ssl_cert` and `ssl_key` parameters to the apache::vhost resource.

  * **puppet_server**: (*string* Default: `$::fqdn`)

  Changing this does not appear to do anything.

  * **puppet_version**: (*string* Default: `installed`)

  Specifies the version of the puppetmaster package to install

  * **server_type**: (*string* Default Puppet 4: `puppetserver` Default Puppet 4: `passenger`)

  Specifies the type of server to use `puppetserver` is always used on Puppet 4

  * **module_path**: **DEPRECATED** (*string* Default: `undef`)

  If this is set, it will be used to populate the basemodulepath parameter in `/etc/puppet/puppet.conf`. This does not impact [environment.conf](http://docs.puppetlabs.com/puppet/latest/reference/config_file_environment.html), which should live in your [r10k](https://github.com/adrienthebo/r10k) environment repo.

  * **pre_module_path**: **DEPRECATED** (*string* Default: `undef`)

  If set, this is prepended to the modulepath parameter *if it is set* and to a static modulepath list if modulepath is unspecified. *A colon separator will be appended to the end of this if needed*

  * **r10k_version**: **DEPRECATED** (*string* Default: `undef`)

  Specifies the version of r10k to install. *It is important to note that the r10k package will be installed via gem*

----

####[Private] Class: **puppet::master::config**
#####*Description*
  The `puppet::master::config` class is responsible for managing the master-specific configuration settings of `puppet.conf`

#####*Parameters*

 * None

----

####[Private] Class: **puppet::master::hiera**
#####*Description*

  The `puppet::master::hiera` class is responsible for configuring hiera, optionally deploying eyaml encryption keys, and setting the ownership of the hieradata path.

#####*Parameters*

 * None

----

####[Private] Class: **puppet::master::install**

#####*Description*

  The `puppet::master::install` class is responsible for installing the packages required to configure a puppetmaster.

#####*Parameters*

 * None

----

####[Private] Class: **puppet::master::passenger**

#####*Description*

  The `puppet::master::passenger` class is responsible for instantiating the apache class, creating the apache vhost, and configuring passenger.

  On Trusty, We need to be able to set SSLCARevocationCheck in apache 2.4+ to enable revocation checks for client certs. According to the [Official puppetlabs docs on passenger](http://docs.puppetlabs.com/guides/passenger.html):
    Apache 2.4 introduces the SSLCARevocationCheck directive and sets it to none
    which effectively disables CRL checking. If you are using Apache 2.4+ you must specify 'SSLCARevocationCheck chain' to actually use the CRL.

#####*Parameters*

 * None


----

####[Private] Class: **puppet::repo**

#####*Description*

This class is responsible for including the proper package repository subclass. This is done based on the osfamily fact.

  * None

----

####[Private] Class: **puppet::repo::apt**

#####*Description*

This class is responsible for optionally managing the presence of the puppetlabs apt repositories. It consults the [$::puppet::manage_repos](#public-class-puppet) param to decide if it should perform any action. If it should, it references [$::puppet::enable_repo](#public-class-puppet)

#####*Parameters*

 * None

----

####[Private] Class: **puppet::repo::yum**

#####*Description*

This class is responsible for optionally managing the presence of the puppetlabs yum repositories. It consults the [$::puppet::manage_repos](#public-class-puppet) param to decide if it should perform any action. If it should, it references [$::puppet::enable_repo](#public-class-puppet)

#####*Parameters*

 * None



##Limitations

It only supports an agent setup on RedHat and CentOS at this stage.
Passenger is only supported on Ubuntu

##Development

Development and testing team consists of @rendhalver and @wolfspyre.
The module gets extensive testing in Abstract IT and it's clients environments.
Pull requests are welcome.

##Contributors

https://github.com/abstractitptyltd/abstractit-puppet/graphs/contributors

##Release Notes/Etc

Check the CHANGELOG.md for release notes and bug fixes.
It's a bit sparse right now and only contains the public releases.
