# Class puppet::master::passenger

class puppet::master::passenger (
  $passenger_max_pool_size      = $puppet::master::params::passenger_max_pool_size,
  $passenger_pool_idle_time     = $puppet::master::params::passenger_pool_idle_time,
  $passenger_stat_throttle_rate = $puppet::master::params::passenger_stat_throttle_rate,
  $passenger_max_requests       = $puppet::master::params::passenger_max_requests,
  $host = $puppet::master::params::host,) inherits puppet::master::params {
  class { 'web': apache_default_mods => false, }

  monit::process { 'puppetmaster':
    ensure   => absent,
    host     => '127.0.0.1',
    port     => '8140',
    protocol => 'HTTP',
  }

  # passenger settings
  class { '::apache::mod::passenger':
    passenger_high_performance   => 'On',
    passenger_max_pool_size      => $passenger_max_pool_size,
    passenger_pool_idle_time     => $passenger_pool_idle_time,
    passenger_stat_throttle_rate => $passenger_stat_throttle_rate,
    passenger_max_requests       => $passenger_max_requests,
    rack_autodetect              => 'Off',
    rails_autodetect             => 'Off',
  }

  # # puppetmaster vhost in apache
  apache::vhost { $host:
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
    ssl_certs_dir     => '/var/lib/puppet/ssl/certs',
    ssl_verify_client => 'optional',
    ssl_verify_depth  => '1',
    ssl_options       => [
      '+StdEnvVars',
      '+ExportCertData'],
    rack_base_uris    => ['/'],
    directories       => [{
        path    => '/usr/share/puppet/rack/puppetmasterd/',
        options => 'None',
        order   => 'allow,deny',
        allow   => 'from all',
      }
      ],
    request_headers   => [
      'unset X-Forwarded-For',
      'set X-SSL-Subject %{SSL_CLIENT_S_DN}e',
      'set X-Client-DN %{SSL_CLIENT_S_DN}e',
      'set X-Client-Verify %{SSL_CLIENT_VERIFY}e',
      ],
    require           => Class['puppet::master::install']
  }
}
