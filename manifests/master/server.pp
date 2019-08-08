# Class puppet::master::server

class puppet::master::server {
  include ::puppet::master
  include ::puppet::defaults
  $sysconfigdir   = $::puppet::defaults::sysconfigdir
  $java_ram       = $::puppet::master::java_ram
  $service_enable = $::puppet::master::service_enable

  ini_subsetting { 'puppet server Xmx java_ram':
    ensure            => present,
    section           => '',
    key_val_separator => '=',
    path              => "${sysconfigdir}/puppetserver",
    setting           => 'JAVA_ARGS',
    subsetting        => '-Xmx',
    value             => $java_ram,
    require           => Class['puppet::master::install']
  }

  ini_subsetting { 'puppet server Xms java_ram':
    ensure            => present,
    section           => '',
    key_val_separator => '=',
    path              => "${sysconfigdir}/puppetserver",
    setting           => 'JAVA_ARGS',
    subsetting        => '-Xms',
    value             => $java_ram,
    require           => Class['puppet::master::install']
  }

  service { 'puppetserver':
    ensure    => $service_enable,
    enable    => $service_enable,
    require   => Class[puppet::master::config],
    subscribe => [
      Class[puppet::master::hiera],
      Class[puppet::master::config],
    ]
  }
}
