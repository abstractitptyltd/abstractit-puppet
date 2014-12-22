# Class puppet::master::hiera

class puppet::master::hiera (
  $env_owner       = $puppet::master::env::env_owner,
  $eyaml_keys      = $puppet::master::env::eyaml_keys,
  $hieradata_path  = $puppet::master::env::hieradata_path,
  $hiera_backends  = $puppet::master::env::hiera_backends,
  $hiera_hierarchy = $puppet::master::env::hiera_hierarchy
) inherits puppet::master::env {

  #input validation
  validate_absolute_path($hieradata_path)
  validate_array($hiera_hierarchy)
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
