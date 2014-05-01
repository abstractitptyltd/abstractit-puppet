## Class puppet::master::modules

class puppet::master::modules (
  $env_owner = $puppet::params::env_owner,
  $r10k_env_basedir = $puppet::params::r10k_env_basedir,
  $r10k_update = $puppet::params::r10k_update,
  $r10k_minutes = $puppet::params::r10k_minutes,
  $cron_minutes = $puppet::params::cron_minutes,
) inherits puppet::params {

  # r10k setup
  file { '/var/cache/r10k':
    ensure => directory,
    owner  => $env_owner,
    group  => $env_owner,
    mode   => '0700',
    require => Package['r10k'],
  }
  file { '/etc/r10k.yaml':
    ensure  => file,
    content => template('puppet/r10k.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/var/cache/r10k'],
  }

  file { $r10k_env_basedir:
    ensure => directory,
    owner  => $env_owner,
    group  => $env_owner,
    mode   => '0755',
  }

  # cron for updating the r10k environment
  # will possibly link thins to a git commit hook at some point
  cron { 'puppet_r10k':
    ensure    => $r10k_update ? {
      default => present,
      false   => absent,
    },
    command => '/usr/local/bin/r10k deploy environment production',
    user    => $env_owner,
    minute  => $r10k_minutes,
  }
  # remove old cron_job file
  site::cron_job { 'puppet_r10k':
    enable   => false,
    interval => 'd',
    script   => "# created by puppet
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
${cron_minutes} * * * * ${env_owner} /usr/local/bin/r10k deploy environment production
",
  }

}
