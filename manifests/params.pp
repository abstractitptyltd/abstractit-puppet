# # Class puppet::params
# setting for the puppet module

class puppet::params {
  $host        = "puppet.${::domain}"
  $server      = 'puppet'
  $environment = 'production'
  $devel_repo  = false
  $reports     = true
}
