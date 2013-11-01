define puppet::environment (
# 	$name,
	$librarian = true,
	$cron_minutes = "0,15,30,45",
) {
	## sets up the files for each environment

	file { "/etc/puppet/environments/${title}":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments"],
	}
	
	file { "/etc/puppet/environments/${title}/Puppetfile":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 640,
		content => template("puppet/${title}/Puppetfile.erb"),
		require => File["/etc/puppet/environments/${title}"],
	}

	file { "/etc/puppet/environments/${title}/Puppetfile.lock":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 644,
		require => File["/etc/puppet/${title}/development"],
	}

	file { "/etc/puppet/environments/${title}/manifests":
		ensure => directory,
		owner => "puppet",
		group => "puppet",
		mode => 755,
		require => File["/etc/puppet/environments/${title}"],
	}
	
	file { "/etc/puppet/environments/${title}/manifests/site.pp":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 644,
		content => template("puppet/${title}/site.pp.erb"),
		require => File["/etc/puppet/environments/${title}/manifests"],
	}

	file { "/etc/puppet/environments/${title}/manifests/nodes.pp":
		ensure => file,
		owner => "puppet",
		group => "puppet",
		mode => 600,
		content => template("puppet/${title}/nodes.pp.erb"),
		require => File["/etc/puppet/environments/${title}/manifests"],
	}

	# cron for updating the ${title} puppet module trees
    cron_job { "puppet_modules_${title}":
    	ensure			=> $librarian,
        interval        => "d",
        script          => "# created by puppet
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

${cron_minutes} * * * * puppet cd /etc/puppet/environments/${title} && librarian-puppet update 2>&1
",
    }

}
