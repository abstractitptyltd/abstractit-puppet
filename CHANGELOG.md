##2015-06-09 - Pete Brown <pete@abstractit.com.au> 2.0.1
###Summary
Bugfix release

####Bugfixes
Add puppet_server_type ro puppetdb profile so we can specify the type of puppet server we run


##2015-06-09 - Pete Brown <pete@abstractit.com.au> 2.0.0
###Summary

This version introduces some backwards incompatible changes with 1.8.x.

I have dropped Ruby 1.8 from spec tests due to inconsistent results. The module should still work on older platforms but I can't guarantee it will.

####Backwards-incompatible changes

#####`puppet::master` class
- `module_path` - This paramater has been removed use `basemodulepath` instead
- `pre_module_path` - This paramater has been removed use `basemodulepath` instead 

#####`puppet::master::modules` class
- This class has been removed in favour of the `puppet::profile::r10k` class

#####`puppet::master::puppetdb` class
- This class has been removed in favour of the `puppet::profile::puppetdb` class

#####`puppet` class
- `devel_repo` - this paramater has been deprecated in favour of the more aptly named `enable_devel_repo` paramater #20

#####`puppet::profile::agent` class
- `devel_repo` This paramater removed use `enable_devel_repo` instead
- `puppet_reports` This paramater has been renamed `reports`

#####`puppet::profile::master` class
- This class no longer configures modules or puppetdb please use r10k and puppetdb profiles for those.
- `r10k_version` This paramater removed
- `module_path` This paramater has been removed use `basemodulepath` instead
- `pre_module_path` This paramater has been removed use `basemodulepath` instead
- `puppet_server` This paramater removed
- `modules` This paramater removed
- `extra_env_repos` This paramater removed
- `hiera_repo` This paramater removed
- `puppet_env_repo` This paramater removed
- `r10k_env_basedir` This paramater removed
- `r10k_minutes` This paramater removed
- `r10k_purgedirs` This paramater removed
- `r10k_update` This paramater removed
- `puppetdb` This paramater removed
- `puppetdb_version` This paramater removed
- `node_purge_ttl` This paramater removed
- `node_ttl` This paramater removed
- `puppetdb_listen_address` This paramater removed
- `puppetdb_server` This paramater removed
- `puppetdb_ssl_listen_address` This paramater removed
- `report_ttl` This paramater removed
- `reports` This paramater removed
- `puppetdb_use_ssl` This paramater removed


####Features
Add initial support for Debian 6 and 7.
Add support for Puppet 4.x and new collections. #42 #41
Add support for the new puppetserver on puppet 3.x and 4.x. #27
Add support for RedHat and CentOS under Puppet 4.x. #38
Add support for using cfacter.
Add support for setting environment_timeout. #39
Add support for managing hiera-eyaml keys. #9
Add support for setting logdest for agents.
Add support for setting START variable in sysconfigdir/puppet. #32
Add variables to configure the puppet reports clean cron. #15
Add puppetboard profile. #40
Added initial puppet-strings docs for main classes and profiles.
Add manage_hiera_config variable to allow people manage hiera config themselves.
Add validation tests for manifests, ruby and templates.
Fixed a few skipped rspec tests.

####Bugfixes
Use reports variable to set reports in puppet conf

####Known bugs
* puppet::master::passenger doesn't work properly under RedHat or CentOS #38


##2015-02-18 - Pete Brown <pete@abstractit.com.au> 1.8.2
###Summary
Bugfix release

####Bugfixes
Fix descriptions in yum repos

####Known bugs
* RedHat support is only available for an agent at this stage


##2015-02-18 - Pete Brown <pete@abstractit.com.au> 1.8.1
###Summary
Bugfix release

####Bugfixes
fix links in metadata.json @rendhalver
Code cleanup


##2015-02-18 - Pete Brown <pete@abstractit.com.au> 1.8.0
###Summary
Bugfix and new feature release
Adding ability to run agent via cron. @wolfspyre
Initial support for running the agent on osfamily == RedHat @rendhalver

####Bugfixes
Spec tests are actually running now! (Well most of them anyhow) @rendhalver
"Fix" POODLE attack by upgrading to new release of puppetlabs-apache @rendhalver
Documentation fixes and updates. @wolfspyre


## 2014-09-18 - Pete Brown <pete@abstractit.com.au> 1.7.6
### Summary
  Bugfix release

####Bugfixes
- remove symlink in fixtures. @rendhalver


---
#### 2014-08-21 - Release 1.7.5
 * set PassengerRoot properly on Ubuntu trusty. @rendhalver

## 2014-07-26 - Release 1.7.4
###Summary
Added spec tests courtesy of @wolfspyre
Variable validitation and type checking courtesy of @wolfspyre
Documentation improvements @wolfspyre
Added operatingsystem_support and requirements to metadata.json @rendhalver

###Bugfixes
- none this time

---
#### 2014-07-21 - Pete Brown <pete@abstractit.com.au> 1.7.3
 * [fix] fixed dependency for inifile to use the right version

#### 2014-07-08 - Pete Brown <pete@abstractit.com.au> 1.7.2
 * Added option for setting runinterval on agent (default 30m)
 * [fix] add missing -p flag to r10k cron
 
#### 2014-07-08 - Pete Brown <pete@abstractit.com.au> 1.7.1
 * [fix] environment to r10k cron
 * [fix] fixed dependencies
 * Added option to disable purging r10k directories

#### 2014-07-07 - Pete Brown <pete@abstractit.com.au> 1.7.0
 * [fix] notify apache::service when hiera.yaml changes
 * [fix] fix name of hiera_backends in master profile
 * Adding support for enabling Structured Facts support from facter 2.1.0
 * Support for adding structured facts via facter.d forthcomming.
 * Renamed a few variables to make their purpose more obvious.

#### 2014-06-18 - Pete Brown <pete@abstractit.com.au> - 1.6.8
 * switch extra_env_repos to optional
 * new hash for hiera_backends

#### 2014-06-18 - Pete Brown <pete@abstractit.com.au> - 1.6.7
 * First Public Release
