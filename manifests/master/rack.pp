# == Class: puppet::master::rack
#
# Install the Puppetmaster Rack configuration files and directories. These
# can be installed by the puppet package itself, but we control them here so
# that we can more easily push templatized configurations in the future.
#
class puppet::master::rack {
  file {
    '/usr/share/puppet/rack':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755';

    '/usr/share/puppet/rack/puppetmasterd':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/usr/share/puppet/rack'];

    '/usr/share/puppet/rack/puppetmasterd/public':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    require => File['/usr/share/puppet/rack/puppetmasterd'];

    '/usr/share/puppet/rack/puppetmasterd/tmp':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    require => File['/usr/share/puppet/rack/puppetmasterd'];

    '/usr/share/puppet/rack/puppetmasterd/config.ru':
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0755',
    source => 'puppet:///modules/puppet/config.ru',
    require => File['/usr/share/puppet/rack/puppetmasterd'];
  }
}
