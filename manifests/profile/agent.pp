class puppet::profile::agent (
  $enabled          = true,
  $puppet_version   = 'installed',
  $hiera_version    = 'installed',
  $facter_version   = 'installed',
  $puppet_server    = 'puppet',
  $environment      = 'production',
  $devel_repo       = false,
  $puppet_host      = "puppet.${::domain}",
  $puppet_reports   = true,
  $structured_facts = false,
  $custom_facts     = undef,) {
  class { 'puppet':
    enabled          => $enabled,
    puppet_version   => $puppet_version,
    hiera_version    => $hiera_version,
    facter_version   => $facter_version,
    puppet_server    => $puppet_server,
    environment      => $environment,
    devel_repo       => $devel_repo,
    reports          => $puppet_reports,
    structured_facts => $structured_facts,
  }

  class { 'puppet::facts':
    custom_facts => $custom_facts,
  }

}
