define puppet::environment (
	$branch = $name,
	$librarian = true,
	$cron_minutes = "0,15,30,45",
	$user = 'puppet',
	$group = 'puppet',
) {
	## sets up the files for each environment

	file { "/etc/puppet/environments/${name}":
		ensure => directory,
		owner => $user,
		group => $group,
		mode => 755,
		require => File["/etc/puppet/environments"],
	}
	
	file { "/etc/puppet/environments/${name}/Puppetfile":
		ensure => file,
		owner => $user,
		group => $group,
		mode => 640,
		content => template("puppet/Puppetfile.erb"),
    #		content => template("puppet/${name}/Puppetfile.erb"),
		require => File["/etc/puppet/environments/${name}"],
	}

	file { "/etc/puppet/environments/${name}/Puppetfile.lock":
		ensure => file,
		owner => $user,
		group => $group,
		mode => 644,
		require => File["/etc/puppet/environments/${name}"],
	}

	file { "/etc/puppet/environments/${name}/manifests":
		ensure => directory,
		owner => 'puppet',
		group => 'puppet',
		mode => 755,
		require => File["/etc/puppet/environments/${name}"],
	}
	
	file { "/etc/puppet/environments/${name}/manifests/site.pp":
		ensure => file,
		owner => 'puppet',
		group => 'puppet',
		mode => 644,
		content => template("puppet/${name}/site.pp.erb"),
		require => File["/etc/puppet/environments/${name}/manifests"],
	}

	gitclone::clone { "manifest_includes":
		real_name  => "includes",
		localtree => "/etc/puppet/environments/${name}/manifests",
		source    => "https://bitbucket.org/pivitptyltd/puppet-manifest-includes.git",
		branch    => $name,
	}
	gitclone::pull { "manifest_includes":
		real_name => "includes",
		localtree => "/etc/puppet/environments/${name}/manifests",
		require   => Gitclone::Clone["manifest_includes"],
	}

	file { "/etc/puppet/environments/${name}/manifests/nodes.pp":
		ensure  => file,
		owner   => 'puppet',
		group   => 'puppet',
		mode    => 600,
		content => template("puppet/${name}/nodes.pp.erb"),
    require => Gitclone::Pull["manifest_includes"],
    #require => File["/etc/puppet/environments/${name}/manifests"],
	}

	# cron for updating the ${name} puppet module trees
    cron_job { "puppet_modules_${name}":
    	enable			=> $librarian,
        interval        => "d",
        script          => "# created by puppet
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

${cron_minutes} * * * * ${user} cd /etc/puppet/environments/${name} && librarian-puppet update 2>&1
",
    }

}
