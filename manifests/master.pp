class puppet::master {

  File {
    owner => 'root',
    group => 'root',
  }

  # setup puppetdb
  class { 'puppetdb':
    ssl_listen_address => '0.0.0.0',
  }
  class { 'puppetdb::master::config':
    puppet_service_name => 'apache2',
  }

  ## setup hiera

  file { '/etc/hiera.yaml':
    ensure  => file,
    content => template('puppet/hiera.yaml.erb'),
    mode    => '0644',
    require => Gitclone::Pull['pivit_hieradata'],
  }
  file { '/etc/puppet/hiera.yaml':
    ensure   => link,
    target   => '/etc/hiera.yaml',
    require  => File['/etc/hiera.yaml'],
  }

  gitclone::clone { 'pivit_hieradata':
    real_name => 'hieradata',
    localtree => '/etc/puppet',
    source    => 'https://bitbucket.org/pivitptyltd/puppet-hieradata',
    branch    => 'production',
  }
  gitclone::pull { 'pivit_hieradata':
    real_name => 'hieradata',
    localtree => '/etc/puppet',
    clean     => false,
    require   => Gitclone::Clone['pivit_hieradata'],
  }

  package { 'puppetmaster-passenger':
    ensure => installed
  }

  monit::process { 'apache2':
    host     => '127.0.0.1',
    port     => '80',
    protocol => 'HTTP',
  }

  file { 'puppet.cfg':
    ensure => file,
    path   => '/usr/local/backups/puppet.cfg',
    source => 'puppet:///modules/puppet/puppet.cfg',
    mode   => '0600',
  }

  package { 'librarian-puppet':
    ensure   => installed,
    provider => gem,
  }

  file { '/etc/puppet/environments':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0755',
  }

  puppet::environment { 'production':
    librarian => true,
  }

  puppet::environment { 'development':
    librarian    => false,
    branch       => 'master',
    cron_minutes => '10,25,40,55',
    user         => 'ubuntu',
    group        => 'ubuntu',
  }

  puppet::environment { 'testing':
    librarian    => false,
    cron_minutes => '5,35',
    branch       => 'master',
    user         => 'ubuntu',
    group        => 'ubuntu',
  }

}
