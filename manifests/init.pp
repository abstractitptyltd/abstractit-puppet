class puppet (
  $enabled     = $puppet::params::enabled,
  $puppet_version,
  $hiera_version,
  $facter_version,
  $server      = $puppet::params::server,
  $environment = $puppet::params::environment,
  $dumptype    = $puppet::params::dumptype,
  $devel_repo  = $puppet::params::devel_repo,
  $host        = $puppet::params::host,
  $reports     = $puppet::params::reports,) inherits puppet::params {
  $ensure = $enabled ? {
    default => 'running',
    false   => 'stopped',
  }
  $enable = $enabled ? {
    default => true,
    false   => false,
  }

  class { 'puppet::repo':
    devel_repo => $devel_repo,
  } ->
  class { 'puppet::facts': } ->
  class { 'puppet::install':
    puppet_version => $puppet_version,
    hiera_version  => $hiera_version,
    facter_version => $facter_version,
  } ->
  class { 'puppet::config':
    server      => $server,
    environment => $environment,
  } ->
  class { 'puppet::agent':
    enable => $enable,
    ensure => $ensure,
  }

  class { 'puppet::backup':
  }
}
