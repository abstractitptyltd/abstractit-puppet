# # Class puppet::params
# setting for the puppet module

class puppet::params {
  $host        = "puppet.${::domain}"
  $server      = 'puppet'
  $environment = 'production'
  $dumptype    = 'root-tar'
  $devel_repo  = false
  $reports     = true
}
