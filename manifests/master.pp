class puppet::master {

    File {
        owner => "root",
        group => "root",
    }

    # setup puppetdb
    class { 'puppetdb': }
    class { 'puppetdb::master::config':
      puppet_service_name => "apache2",
    }

    package { "puppetmaster-passenger": 
        ensure => installed
    }

    file { "apache2.monitrc":
        ensure => file,
        path => "/etc/monit/conf.d/apache2.monitrc",
        source => "puppet:///modules/apache2/apache2.monitrc",
        mode => 644,
        notify => Service["monit"],
    }

    file { "puppet.cfg":
        ensure => file,
        path => "/usr/local/backups/puppet.cfg",
        source => "puppet:///modules/puppet/puppet.cfg",
        mode => 600,
    }

	package { "librarian-puppet":
		ensure => installed,
		provider => gem,
	}

	file { "/etc/puppet/environments":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
	}

	puppet::environment { "production":
		librarian => true,
	}

	puppet::environment { "development":
		librarian => false,
		branch => "master",
		cron_minutes => "10,25,40,55",
		user => 'ubuntu',
		group => 'ubuntu',
	}

}
