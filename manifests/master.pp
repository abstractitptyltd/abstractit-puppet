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

	file { "/etc/puppet/environments":
		owner => "puppet",
		group => "puppet",
		mode => 755,
	}
	
	file { "/etc/puppet/environments/production":
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments"],
	}
	
	file { "/etc/puppet/environments/development":
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments"],
	}

	# crons for updating the puppet module trees
}
