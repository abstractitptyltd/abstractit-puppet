# Class puppet::profile::puppetboard
# The puppet::profile::puppetboard class is responsible for setting up puppetboard node
#
# @puppet::profile::puppetboard when declaring the puppet::profile::puppetboard class
#   include puppet::profile::puppetboard
#
# @param revision [String] Default: undef
#   Revision of puppetboard to install (tag,branch or commit)
# @param unresponsive [String] Default: 3
#   Number of hours after which a node is considered unresponsive
# @param reports_count [String] Default: undef
#   Number of reports to show
# @param vhost_name [String] Default: undef
#   Vhost name
# @param port [String] Default: 5000
#   Revision of puppetboard to install (tag,branch or commit)
# @param puppetdb_port [String] Default: 8080
#   Port to use for communicating with PuppetDB
# @param puppetdb_host [String] Default: localhost
#   Hostname to use for communicating with PuppetDB
# @param git_source [String] Default: https://github.com/puppet-community/puppetboard/
#   Repo to install puppetboard from 
# @param manage_virtualenv [Boolean] Default: true
#   Whether to manage virtualenv

class puppet::profile::puppetboard (
  $revision          = undef,
  $unresponsive      = '3',
  $reports_count     = undef,
  $vhost_name        = 'pboard',
  $port              = '5000',
  $puppetdb_port     = '8080',
  $puppetdb_host     = 'localhost',
  $git_source        = 'https://github.com/puppet-community/puppetboard/',
  $manage_virtualenv = true,
) {
  include ::apache

  class { '::apache::mod::wsgi':
  }

  class { '::puppetboard':
    reports_count     => $reports_count,
    unresponsive      => $unresponsive,
    revision          => $revision,
    git_source        => $git_source,
    puppetdb_port     => $puppetdb_port,
    puppetdb_host     => $puppetdb_host,
    manage_virtualenv => $manage_virtualenv,
  }

  class { '::puppetboard::apache::vhost':
    vhost_name => $vhost_name,
    port       => $port,
  }
}
