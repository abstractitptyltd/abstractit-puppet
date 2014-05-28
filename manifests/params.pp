# # Class puppet::params
# setting for the puppet module

class puppet::params (
  $enabled     = true,
  $puppet_version,
  $hiera_version,
  $facter_version,
  $server      = 'puppet',
  $environment = 'production',
  $dumptype    = 'root-tar',
  $devel_repo  = false,
  $host        = $::servername,
  $reports     = true,) {
  $ensure = $enabled ? {
    default => 'running',
    false   => 'stopped',
  }
  $enable = $enabled ? {
    default => true,
    false   => false,
  } }
