class puppet::profile::agent (
  $puppet_enabled     = true,
  $puppet_version     = 'installed',
  $hiera_version      = 'installed',
  $facter_version     = 'installed',
  $puppet_server      = 'puppet',
  $puppet_environment = 'production',
  $puppet_devel_repo  = false,
  $puppet_host        = "puppet.${::domain}",
  $puppet_reports     = true,
  $custom_facts       = undef,) {
  class { 'puppet':
    enabled        => $puppet_enabled,
    puppet_version => $puppet_version,
    hiera_version  => $hiera_version,
    facter_version => $facter_version,
    server         => $puppet_server,
    environment    => $puppet_environment,
    devel_repo     => $puppet_devel_repo,
    host           => $puppet_host,
    reports        => $puppet_reports,
  }

  class { 'puppet::facts':
    custom_facts => $custom_facts,
  }

}
