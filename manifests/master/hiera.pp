# Class puppet::master::hiera

class puppet::master::hiera {
  include ::puppet::master
  include ::puppet::defaults

  $codedir                            = $puppet::defaults::codedir
  $env_owner                          = $puppet::master::env_owner
  $eyaml_keys                         = $puppet::master::eyaml_keys
  $hiera_backends                     = $puppet::master::hiera_backends
  $hierarchy                          = $puppet::master::hiera_hierarchy
  $manage_hiera_config                = $puppet::master::manage_hiera_config
  $hiera_eyaml_key_directory          = $puppet::master::hiera_eyaml_key_directory
  $hiera_eyaml_pkcs7_private_key      = $puppet::master::hiera_eyaml_pkcs7_private_key
  $hiera_eyaml_pkcs7_public_key       = $puppet::master::hiera_eyaml_pkcs7_public_key
  $hiera_eyaml_pkcs7_private_key_file = $puppet::master::hiera_eyaml_pkcs7_private_key_file
  $hiera_eyaml_pkcs7_public_key_file  = $puppet::master::hiera_eyaml_pkcs7_public_key_file
  $hiera_merge_behavior               = $puppet::master::hiera_merge_behavior

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
  if ( $eyaml_keys and $hiera_eyaml_pkcs7_private_key_file and $hiera_eyaml_pkcs7_public_key_file ){
    file { $hiera_eyaml_key_directory:
      ensure => directory,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0700',
    }

    file { "${hiera_eyaml_key_directory}/${hiera_eyaml_pkcs7_private_key}":
      ensure => file,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0600',
      source => $hiera_eyaml_pkcs7_private_key_file,
    }

    file { "${hiera_eyaml_key_directory}/${hiera_eyaml_pkcs7_public_key}":
      ensure => file,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0600',
      source => $hiera_eyaml_pkcs7_public_key_file,
    }
  }

}
