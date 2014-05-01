## Class puppet::master::hiera

class puppet::master::hiera (
  $hieradata_path = $puppet::params::hieradata_path,
  $env_owner = $puppet::params::env_owner,
) inherits puppet::params {

  ## setup hiera
  file { '/etc/puppet/keys':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0700',
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

  # need to keep this till I get hiera-gpg working properly
  vcsrepo { '/etc/puppet/hieradata':
    ensure   => latest,
    revision => 'production',
    provider => git,
    owner    => $env_owner,
    group    => $env_owner,
    source   => 'https://bitbucket.org/pivitptyltd/puppet-hieradata',
  }

}
