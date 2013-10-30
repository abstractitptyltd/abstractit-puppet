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
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
	}
/*
	file { "/etc/puppet/environments/production":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments"],
	}
	
	file { "/etc/puppet/environments/production/manifests":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments/production"],
	}
	
	file { "/etc/puppet/environments/production/Puppetfile":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 640,
		content => template("puppet/production/Puppetfile.erb"),
		require => File["/etc/puppet/environments/production"],
	}

	# cron for updating the production puppet module trees
	cron {"librarian-puppet production":
		command  => "cd /etc/puppet/environments/production && librarian-puppet update",
		user     => puppet,
		hour     => "*/2",
		minute   => 0,
		require  => File["/etc/puppet/environments/production/Puppetfile"],
	}

*/
	file { "/etc/puppet/environments/development":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments"],
	}

	file { "/etc/puppet/environments/development/Puppetfile":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 644,
		content => template("puppet/development/Puppetfile.erb"),
		require => File["/etc/puppet/environments/development"],
	}

	file { "/etc/puppet/environments/development/manifests":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments/development"],
	}

	file { "/etc/puppet/environments/development/manifests/site.pp":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 644,
		content => template("puppet/development/site.pp.erb"),
		require => File["/etc/puppet/environments/development/manifests"],
	}

	file { "/etc/puppet/environments/development/manifests/nodes.pp":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 600,
		content => template("puppet/development/nodes.pp.erb"),
		require => File["/etc/puppet/environments/development/manifests"],
	}

	# cron for updating the development puppet module trees
	cron {"librarian-puppet development":
		command  => "cd /etc/puppet/environments/development && librarian-puppet update",
		user     => puppet,
		hour     => "*",
		minute   => 0,
		require  => File["/etc/puppet/environments/development/Puppetfile"],
	}
}
