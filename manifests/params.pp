# # Class puppet::params
# setting for the puppet module

class puppet::params {
  $server      = 'puppet'
  $environment = 'production'
  $dumptype    = 'root-tar'
  $devel_repo  = false
  $host        = $::servername
  $reports     = true
}
