class puppet (
  $devel_repo                = $puppet::params::devel_repo,
  $enabled                   = true,
  $environment               = $puppet::params::environment,
  $facter_version            = 'installed',
  $hiera_version             = 'installed',
  $manage_etc_facter         = true,
  $manage_etc_facter_facts_d = true,
  $puppet_server             = $puppet::params::puppet_server,
  $puppet_version            = 'installed',
  $reports                   = $puppet::params::reports,
  $runinterval               = $puppet::params::runinterval,
  $structured_facts          = false,) inherits puppet::params {
  #input validation
  validate_bool(
    $devel_repo,
    $enabled,
    $manage_etc_facter,
    $manage_etc_facter_facts_d,
    $reports,
    $structured_facts,
    )

  validate_string(
    $environment,
    $facter_version,
    $hiera_version,
    $puppet_server,
    $puppet_version,
    $runinterval,
  )

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
  class { 'puppet::install':
    puppet_version => $puppet_version,
    hiera_version  => $hiera_version,
    facter_version => $facter_version,
  } ->
  class { 'puppet::config':
    puppet_server    => $puppet_server,
    environment      => $environment,
    runinterval      => $runinterval,
    structured_facts => $structured_facts,
  } ~>
  class { 'puppet::agent':
    ensure => $ensure,
    enable => $enable,
  }
  include puppet::facts
}
