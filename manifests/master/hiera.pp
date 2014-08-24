# Class puppet::master::hiera

class puppet::master::hiera (
) {
  include ::puppet::master

  $env_owner      = $puppet::master::env_owner
  $eyaml_keys     = $puppet::master::eyaml_keys
  $hiera_backends = $puppet::master::hiera_backends
  $hieradata_path = $puppet::master::hieradata_path
  $hierarchy      = $puppet::master::hiera_hierarchy

  #input validation
  validate_absolute_path($hieradata_path)

  validate_array($hierarchy)

  validate_bool($eyaml_keys)

  validate_hash($hiera_backends)

  validate_string($env_owner)

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
    notify  => Class['apache::service']
  }

  file { '/etc/puppet/hiera.yaml':
    ensure  => link,
    target  => '/etc/hiera.yaml',
    require => File['/etc/hiera.yaml']
  }

  # eyaml for hiera
  if $eyaml_keys {
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
  }

}
