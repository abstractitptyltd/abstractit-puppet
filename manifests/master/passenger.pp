# Class puppet::master::passenger

class puppet::master::passenger {
  include ::puppet::master
  $passenger_max_pool_size      = $::puppet::master::passenger_max_pool_size
  $passenger_max_requests       = $::puppet::master::passenger_max_requests
  $passenger_pool_idle_time     = $::puppet::master::passenger_pool_idle_time
  $passenger_stat_throttle_rate = $::puppet::master::passenger_stat_throttle_rate
  $puppet_fqdn                  = $::puppet::master::puppet_fqdn
  $puppet_version               = $::puppet::master::puppet_version
  if ($::operatingsystem == 'Debian') {
    $vhost_cfg = 'puppetmaster'
  } else {
    $vhost_cfg = 'puppetmaster.conf'
  }

  if ( versioncmp($::puppetversion, '4.0.0') < 0 ) {
    # only set this up on puppetversion < 4
    service { 'puppetmaster':
      ensure  => stopped,
      enable  => false,
      require => Class['puppet::master::install'],
    }

    file { "/etc/apache2/sites-enabled/${vhost_cfg}":
      ensure  => absent,
      require => Package['puppetmaster-passenger']
    }

    file { "/etc/apache2/sites-available/${vhost_cfg}":
      ensure  => absent,
      require => Package['puppetmaster-passenger']
    }

    package { 'puppetmaster-passenger':
      ensure  => $puppet_version,
      require => [
        Class['puppet::master::install'],
        Service['puppetmaster']]
    }

    include ::apache

    # passenger settings
    class { '::apache::mod::passenger':
      passenger_high_performance   => 'On',
      passenger_max_pool_size      => $passenger_max_pool_size,
      passenger_pool_idle_time     => $passenger_pool_idle_time,
      passenger_stat_throttle_rate => $passenger_stat_throttle_rate,
      passenger_max_requests       => $passenger_max_requests
    }

    apache::vhost { $puppet_fqdn:
      docroot            => '/usr/share/puppet/rack/puppetmasterd/public/',
      docroot_owner      => 'root',
      docroot_group      => 'root',
      passenger_app_root => '/usr/share/puppet/rack/puppetmasterd',
      port               => '8140',
      ssl                => true,
      ssl_crl_check      => 'chain',
      ssl_cert           => "/var/lib/puppet/ssl/certs/${puppet_fqdn}.pem",
      ssl_key            => "/var/lib/puppet/ssl/private_keys/${puppet_fqdn}.pem",
      ssl_chain          => '/var/lib/puppet/ssl/certs/ca.pem',
      ssl_ca             => '/var/lib/puppet/ssl/certs/ca.pem',
      ssl_crl            => '/var/lib/puppet/ssl/ca/ca_crl.pem',
      ssl_certs_dir      => '/var/lib/puppet/ssl/certs',
      ssl_verify_client  => 'optional',
      ssl_verify_depth   => '1',
      ssl_options        => [
        '+StdEnvVars',
        '+ExportCertData'],
      rack_base_uris     => ['/'],
      directories        => [{
          path    => '/usr/share/puppet/rack/puppetmasterd/',
          options => 'None'
        }
        ],
      request_headers    => [
        'unset X-Forwarded-For',
        'set X-SSL-Subject %{SSL_CLIENT_S_DN}e',
        'set X-Client-DN %{SSL_CLIENT_S_DN}e',
        'set X-Client-Verify %{SSL_CLIENT_VERIFY}e',
        ],
      subscribe          => Class['puppet::master::install'],
      require            => Package['puppetmaster-passenger'],
    }
  }
}
