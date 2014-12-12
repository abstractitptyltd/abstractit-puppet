# == Class: puppet::master::ssl
#
# Manages all of the SSL certificates for the Puppet Master. Generates the
# actual puppet master certificates based on the supplied CA information.
#
# === Required Parameters
#
# [*puppet_ca_cert*]
#   The contents of the Puppet CA Certificate File
#
# [*puppet_ca_key*]
#   The contents of the Puppet CA Private Key file
#
# === Optional Parameters
#
# [*puppet_fqdn*]
#   The Puppet Master FQDN.
#   (default: $puppet::master::env::puppet_Fqdn)
#
# [*puppet_ca_pass*]
#   The Puppet CA Private Key Password (if necessary)
#   (default: undef)
#
class puppet::master::ssl (
  $puppet_ca_cert,
  $puppet_ca_key,
  $puppet_ca_pass = $puppet::master::env::puppet_ca_pass,
  $puppet_fqdn    = $puppet::master::env::puppet_fqdn,
) inherits puppet::master::env {

  validate_string(
    $puppet_ca_cert,
    $puppet_ca_key,
    $puppet_ca_pass,
    $puppet_fqdn)

  if $puppet_ca_pass {
    validate_string($puppet_ca_pass)
    $puppet_ca_pass_ensure = file
  } else {
    $puppet_ca_pass_ensure = absent
  }

  # Note, file permissions are not managed here. They're managed internally by
  # Puppet, so anything set here would simply be overridden.
  file {
    '/var/lib/puppet/ssl':
    ensure => directory;

    '/var/lib/puppet/ssl/ca':
    ensure  => directory,
    require => File['/var/lib/puppet/ssl'];

    '/var/lib/puppet/ssl/ca/private':
    ensure  => directory,
    require => File['/var/lib/puppet/ssl/ca'];

    '/var/lib/puppet/ssl/ca/ca_crt.pem':
    ensure  => file,
    owner   => puppet,
    group   => puppet,
    content => $puppet_ca_cert,
    notify  => Exec['generate_puppet_ssl_cert'],
    require => File['/var/lib/puppet/ssl/ca'];

    '/var/lib/puppet/ssl/ca/ca_key.pem':
    ensure  => file,
    owner   => puppet,
    group   => puppet,
    content => $puppet_ca_key,
    notify  => Exec['generate_puppet_ssl_cert'],
    require => File['/var/lib/puppet/ssl/ca'];

    '/var/lib/puppet/ssl/ca/private/ca.pass':
    ensure  => $puppet_ca_pass_ensure,
    owner   => puppet,
    group   => puppet,
    content => $puppet_ca_pass,
    notify  => Exec['generate_puppet_ssl_cert'],
    require => File['/var/lib/puppet/ssl/ca/private'];
  }

  # The serial file cannot start out empty, as it will conflict with
  # other puppet masters. Instead, if the file is empty, we actually
  # populate it with a huge number to start creating certificates at.
  # This number is somewhat randomly generated...
  $serialnum = fqdn_rand(2000000)
  exec { 'create_initial_serial':
    command => "/bin/echo ${serialnum} > /var/lib/puppet/ssl/ca/serial",
    creates => '/var/lib/puppet/ssl/ca/serial',
    require => File['/var/lib/puppet/ssl/ca'];
  }

  # Now using the supplied CA and CA Key, generate a new SSL certificate
  # for the puppet master. Note, we also generate a test cert, and then
  # revoke it so that we automatically create a local CRL file.
  exec { 'generate_puppet_ssl_cert':
    command   => "puppet cert -g ${puppet_fqdn} && \
                  puppet cert -g test.test.com && \
                  puppet cert -r test.test.com",
    creates   => "/var/lib/puppet/ssl/certs/${puppet_fqdn}.pem",
    path      => ['/usr/local/sbin', '/usr/local/bin',
                  '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    require   => Exec['create_initial_serial'];
  }
}
