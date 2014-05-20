## Class puppet::master::hiera

class puppet::master::hiera (
  $hieradata_path = $puppet::master::params::hieradata_path,
  $env_owner = $puppet::master::params::env_owner,
  $hiera_repo = $puppet::master::params::hiera_repo,
  $eyaml = $puppet::master::params::eyaml,
  $hiera_yaml_path = $puppet::master::params::hiera_eyaml_path,
  $hiera_eyaml_path = $puppet::master::params::hiera_eyaml_path,
  $hiera_gpg_path = $puppet::master::params::hiera_gpg_path,
) inherits puppet::master::params {

  ## setup hiera
  file { '/etc/puppet/keys':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0700',
  }
  # eyaml keys
  file { '/etc/puppet/keys/eyaml':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0700',
  }
  file { '/etc/puppet/keys/eyaml/private_key.pkcs7.pem':
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0600',
    source => 'puppet:///modules/local/eyaml/private_key.pkcs7.pem',
  }
  file { '/etc/puppet/keys/eyaml/public_key.pkcs7.pem':
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0600',
    source => 'puppet:///modules/local/eyaml/public_key.pkcs7.pem',
  }

  file { $hieradata_path:
    ensure => directory,
    owner  => $env_owner,
    group  => $env_owner,
    mode   => '0755',
  }

  file { '/etc/hiera.yaml':
    ensure  => file,
    content => template('puppet/hiera.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  file { '/etc/puppet/hiera.yaml':
    ensure   => link,
    target   => '/etc/hiera.yaml',
    require  => File['/etc/hiera.yaml'],
  }
/*
  # need to keep this till I get hiera-gpg working properly
  vcsrepo { '/etc/puppet/hieradata':
    ensure   => latest,
    revision => 'production',
    provider => git,
    owner    => $env_owner,
    group    => $env_owner,
    user     => 'root',
    source   => $hiera_repo,
    require  => [
      Site::User::Githostkey["${env_owner}_bitbucket.org"],
      Site::User::Githostkey["${env_owner}_altssh.bitbucket.org"],
      Site::User[$env_owner],
    ]
  }
*/
}
