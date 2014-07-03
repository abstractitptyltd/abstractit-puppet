# # Class puppet::params
# setting for the puppet module

class puppet::params {
  $puppet_server = 'puppet'
  $environment   = 'production'
  $devel_repo    = false
  $reports       = true
}
