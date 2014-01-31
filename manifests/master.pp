class puppet::master (
  $host = $::servername,
) {

  include site::monit::apache
  include apache

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
  #class { 'puppetboard':
  #}
  #class { 'puppetboard::apache::conf':
  #}

  class { 'apache::mod::passenger':
    passenger_high_performance   => 'On',
    passenger_max_pool_size      => '12',
    passenger_pool_idle_time     => '1500',
    passenger_stat_throttle_rate => '120',
    rack_autodetect              => 'Off',
    rails_autodetect             => 'Off',
  }

  apache::vhost{ 'puppetmaster':
    docroot           => '/usr/share/puppet/rack/puppetmasterd/public/',
    docroot_owner     => 'root',
    docroot_group     => 'root',
    port              => '8140',
    ssl               => true,
    ssl_protocol      => '-ALL +SSLv3 +TLSv1',
    ssl_cipher        => 'ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP',
    ssl_cert          => "/var/lib/puppet/ssl/certs/${host}.pem",
    ssl_key           => "/var/lib/puppet/ssl/private_keys/${host}.pem",
    ssl_chain         => '/var/lib/puppet/ssl/certs/ca.pem',
    ssl_ca            => '/var/lib/puppet/ssl/certs/ca.pem',
    ssl_crl           => '/var/lib/puppet/ssl/ca/ca_crl.pem',
    ssl_certs_dir     => undef,
    ssl_verify_client => 'optional',
    ssl_verify_depth  => '1',
    ssl_options       => ['+StdEnvVars','+ExportCertData'],
    rack_base_uris    => ['/'],
    directories       => [
      { path          => '/usr/share/puppet/rack/puppetmasterd/',
        options       => 'None',
        order         => 'allow,deny',
        allow         => 'from all',
      }
    ],
    request_headers   => [
      'unset X-Forwarded-For',
      'set X-SSL-Subject %{SSL_CLIENT_S_DN}e',
      'set X-Client-DN %{SSL_CLIENT_S_DN}',
      'set X-Client-Verify %{SSL_CLIENT_VERIFY}e',
    ],
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
