## Class puppet::master::hiera

class puppet::master::hiera (
  $hieradata_path = $puppet::master::params::hieradata_path,
  $env_owner = $puppet::master::params::env_owner,
  $hiera_repo = $puppet::master::params::hiera_repo,
  $git_protocol = $puppet::master::params::git_protocol,
) inherits puppet::master::params {

  $git_user = $git_protocol ? {
    default  => $env_owner,
    'https' => 'root',
  }

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
    user     => $git_user,
    source   => $hiera_repo,
    require  => [
      Site::User::Githostkey["${env_owner}_bitbucket.org"],
      Site::User[$env_owner],
    ]
  }

}
