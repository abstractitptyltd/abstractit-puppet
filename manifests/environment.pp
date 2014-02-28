define puppet::environment (
  $branch = $name,
  $mod_env = $name,
  $librarian = true,
  $cron_minutes = '0,15,30,45',
  $user = 'puppet',
  $group = 'puppet',
) {
  ## sets up the files for each environment

  $forge_mods = hiera("puppet::${mod_env}::forge_modules", {})
  $upstream_mods = hiera("puppet::${mod_env}::upstream_modules", {})
  $local_mods = hiera("puppet::${mod_env}::local_modules", [])
  #$forge_mods = hiera("puppet::environment::${mod_env}::forge_modules")
  #$upstream_mods = hiera("puppet::environment::${mod_env}::upstream_modules", {})
  #$local_mods = hiera("puppet::environment::${mod_env}::local_modules", $puppet::master::local_modules)

  file { "/etc/puppet/environments/${name}":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => File['/etc/puppet/environments'],
  }

  file { "/etc/puppet/environments/${name}/Puppetfile":
    ensure   => file,
    owner    => $user,
    group    => $group,
    mode     => '0640',
    content  => template('puppet/Puppetfile.erb'),
    require  => File["/etc/puppet/environments/${name}"],
  }

  file { "/etc/puppet/environments/${name}/Puppetfile.lock":
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    require => File["/etc/puppet/environments/${name}"],
  }

  file { "/etc/puppet/environments/${name}/manifests":
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0755',
    require => File["/etc/puppet/environments/${name}"],
  }

  file { "/etc/puppet/environments/${name}/manifests/site.pp":
    ensure  => file,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    content => template('puppet/site.pp.erb'),
    require => File["/etc/puppet/environments/${name}/manifests"],
  }

  vcsrepo { "/etc/puppet/environments/${name}/manifests/includes":
    ensure   => latest,
    revision => $branch,
    provider => git,
    owner    => puppet,
    group    => puppet,
    source   => 'https://bitbucket.org/pivitptyltd/puppet-manifest-includes',
  }
  # cron for updating the ${name} puppet module trees
  cron_job { "puppet_modules_${name}":
    enable   => $librarian,
    interval => 'd',
    script   => "# created by puppet
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

${cron_minutes} * * * * ${user} cd /etc/puppet/environments/${name} && librarian-puppet update 2>&1
",
  }

}
