# Class puppet::master::hiera

class puppet::master::hiera {
  include ::puppet::master
  include ::puppet::defaults

  $codedir             = $puppet::defaults::codedir
  $env_owner           = $puppet::master::env_owner
  $eyaml_keys          = $puppet::master::eyaml_keys
  $hiera_backends      = $puppet::master::hiera_backends
  $hierarchy           = $puppet::master::hiera_hierarchy
  $manage_hiera_config = $puppet::master::manage_hiera_config

  if ($manage_hiera_config == true) {
    file { "${codedir}/hiera.yaml":
      ensure  => file,
      content => template('puppet/hiera.yaml.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
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
