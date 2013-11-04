class puppet::master {

    File {
        owner => "root",
        group => "root",
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
		cron_minutes => "10,25,40,55",
	}

}
