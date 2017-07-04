##2017-07-02 - Pete Brown <rendhalver@users.noreply.github.com> 2.4.0
###Summary
Feature: Add more parameters to R10K profile (PR #141)
Feature: Add parameter to determine whether to manage puppetdb database (PR #144)
Feature: Add support for show_diff parameter (PR #145)
Feature: Add support for puppet 4.10.1 (PR #150)
Feature: Change to puppet/r10k module (PR #131)
Add license file (PR #155)

####Bugfixes
Fix #142 Move server setting to main (PR #143)
Notify agent service when package is upgraded (PR #149)

##2016-10-10 - Pete Brown <pete@abstractit.com.au> 2.3.0
###Summary
Numerous bugfixes.
Feature: Configure agents using SRV records @aaron-miller
Feature: Added parameter manage_dbserver to profiles/master @chrisowensboston

####Bugfixes
Fix puppet group in puppet 4 @seanscottking
Update Puppetlabs apt keys @rdvh
Fix puppetserver should connect to non SSL puppetdb via http not https @divansantana
Update metadata.json to allow use of zack-r10k version 3.2.0 @rpkish
Define relationship between sysconfig and service in agent @toepi
Deploy puppetdb ssl certs when ssl is enabled @divansantana
Fix r10k manage_ruby_dependency error @divansantana
Fix could not find init script in some cases @divansantana
Support for strict_variables mode @tequeter
define relationship between vhost an package puppetmaster-passenger @toepi
distinguish between Debian and Ubuntu for puppetmaster-passenger setup @toepi
Add support for splay and splaylimit parameters in puppet.conf @paulseward
Fix syntax error on readme @jordigg
in manifests/repo.pp added include ::puppet, to fix unknown variable puppet::manage_repos @chrisowensboston
in manifests/init.pp added "+ 0" after calls to fqdn_rand, to force conversion to integer. @chrisowensboston
in spec/classes/puppet_agent_spec.rb, Changed tests for interpolated minute values to accommodate different versions of fqdn_rand using different entropy sources. Changed host name from "testy" to "testy2" because "testy" happened to give a 0 using fqdn_rand(14)
In .fixtures.yml, changed puppetlabs/concat version requirement from '1.2.0' to '>= 1.2.2 < 2.0.0', to fix "uknown variable ::is_pe" bug @chrisowensboston
in Gemfile, forced json_pure to be < 2.0.1 when ruby < 2.0 @chrisowensboston
in .travis.yml, added a line for rvm 2.2.0, puppet gem 4.7.0, facter gem 2.4.6, hiera gem 3.2.1 @chrisowensboston


##2016-02-11 - Pete Brown <pete@abstractit.com.au> 2.2.1
###Summary

####Bugfixes
Fix agent cron so it is quiet on sucess. @johnny-die-tulpe
Fix master profile so it works when puppetdb is on remote node. @divansantana

##2016-01-29 - Pete Brown <pete@abstractit.com.au> 2.2.0
###Summary

Upgrade puppetdb and postgresql modules to latest versions to get support for PuppetDB 3.x
Add support for puppetlabs-apt 2.1.0+
Move puppetmaster config setup from puppetdb profile into master profile.
Make hiera-eyaml package optional. @tequeter
New define puppet::setting for adding any setting to puppet.conf
Add support for hiera merge_behaviour. @jaxim

####NOTE
This module is compatible with the 1.8 series of apt and 2.1.0 and above
2.0.0 does not work due to the missing compatibility layer addded in 2.1.0.
This is due to the postgresql module still using apt 1.8.

####Bugfixes
Added support for new versions of above mentioned modules.
manage_virtualenv variable wasn't being used in puppetboard profile. @gwarf
preferred_serialization_format wasn't being reverted if it wasn't set to msgpack. Thanks to @topei for spotting this.
Move management of facter.d directory out of puppet::facts so it gets setup if the class is not used. Thanks to @topei for spotting this.
Fix hiera-eyaml install on Puppet 4. Thanks @jaxim
Fix for r10k purgedirs error as that parameter is now deprecated in upstream module. Thanks @divansantana
Fixed yum gpg key for yum repos. @djjudas21
Fixed repo management to only use one method to manage the repository. Thanks @djjudas21
Fixed agent start/restart on Ubuntu. @TravellingGuy

##2015-07-14 - Pete Brown <pete@abstractit.com.au> 2.1.2
###Summary

Port variable was not being used for puppetboard profile
Add variable to set hostname for puppetdb puppetboard profile

####Bugfixes

##2015-07-13 - Pete Brown <pete@abstractit.com.au> 2.1.1
###Summary

Adding variables to set ports for puppetdb in puppetdb and puppetboard profiles

####Bugfixes

##2015-07-08 - Pete Brown <pete@abstractit.com.au> 2.1.0
###Summary

This version adds basic autosigning functionaliy which ignores the current  autosign parameter.

Autosigning is now managed with the autosign_method, autosign_file and autosign_domains variables.

Given that autosigning  didn't enabled autosign in a production environment it won't break any of your current production environments with default setings.

Add option for setting a ca_server.
Add option to set preferred_serialization_format for testing msgpack

####Bugfixes


##2015-06-10 - Pete Brown <pete@abstractit.com.au> 2.0.2
###Summary
Spec test cleanup.
Fixing deployment condition for Travis.
Added all vars to r10k profile
Added r10k_update_env var to r10k profile for setting environment to update
Reducting the tested os versions as most tests are duplicated 10 times which is excessive and time consuming

####Bugfixes
hiera_eyaml vars were missing from puppet::master::profile

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
