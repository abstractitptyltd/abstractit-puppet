# == Class: puppet::env
#
# Common variables and settings for the `puppet` class.
#
class puppet::env {
  $puppet_version = 'installed'
  $hiera_version  = 'installed'
  $facter_version = 'installed'
}
