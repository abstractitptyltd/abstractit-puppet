define puppet::environment (
	$librarian = true,
	$cron_minutes = "0,15,30,45",
) {
	## sets up the files for each environment

	file { "/etc/puppet/environments/${name}":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments"],
	}
	
	file { "/etc/puppet/environments/${name}/Puppetfile":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 640,
		content => template("puppet/${name}/Puppetfile.erb"),
		require => File["/etc/puppet/environments/${name}"],
	}

	file { "/etc/puppet/environments/${name}/Puppetfile.lock":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 644,
		require => File["/etc/puppet/${name}/development"],
	}

	file { "/etc/puppet/environments/${name}/manifests":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments/${name}"],
	}
	
	file { "/etc/puppet/environments/${name}/manifests/site.pp":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 644,
		content => template("puppet/${name}/site.pp.erb"),
		require => File["/etc/puppet/environments/${name}/manifests"],
	}

	file { "/etc/puppet/environments/${name}/manifests/nodes.pp":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 600,
		content => template("puppet/${name}/nodes.pp.erb"),
		require => File["/etc/puppet/environments/${name}/manifests"],
	}

	# cron for updating the ${name} puppet module trees
    cron_job { "puppet_modules_${name}":
    	ensure			=> $librarian,
        interval        => "d",
        script          => "# created by puppet
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

${cron_minutes} * * * * puppet cd /etc/puppet/environments/${name} && librarian-puppet update 2>&1
",
    }

}
