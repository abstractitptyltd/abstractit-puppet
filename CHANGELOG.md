## 2014-07-08 - Pete Brown <pete@abstractit.com.au> 1.7.2
### Summary
Added option for setting runinterval on agent (default 30m)

####Bugfixes
- add missing -p flag to r10k cron

####Known bugs
* No known bugs. Please let us know if you find any.

---
##### 2014-07-08 - Pete Brown <pete@abstractit.com.au> 1.7.1
 * [fix] environment to r10k cron
 * [fix] fixed dependencies
 * Added option to disable purging r10k directories

##### 2014-07-07 - Pete Brown <pete@abstractit.com.au> 1.7.0
 * [fix] notify apache::service when hiera.yaml changes
 * [fix] fix name of hiera_backends in master profile
 * Adding support for enabling Structured Facts support from facter 2.1.0
 * Support for adding structured facts via facter.d forthcomming.
 * Renamed a few variables to make their purpose more obvious.

##### 2014-06-18 - Pete Brown <pete@abstractit.com.au> - 1.6.8

 * switch extra_env_repos to optional
 * new hash for hiera_backends

##### 2014-06-18 - Pete Brown <pete@abstractit.com.au> - 1.6.7

 * First Public Release
