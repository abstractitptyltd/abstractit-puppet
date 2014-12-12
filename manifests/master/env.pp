# == Class: puppet::master::env
#
# Common puppet master install variables
#
class puppet::master::env {
  # If we want the Puppet SSL certificate to be generated dynamically,
  # set $manage_ssl to True and supply a $puppet_ca_cert/$puppet_ca_key
  # to the puppet::master class.
  $manage_ssl = false

  # If this is left as undef, then the ca.pass file is not created even
  # if $manage_ssl is set to True. This means that the ca.pem/ca.key
  # passed into puppet::master::ssl must not require a password to open
  # the key file.
  $puppet_ca_pass = undef
  $puppet_ca_cert = undef
  $puppet_ca_key  = undef

  # puppet::master::config settings
  $dns_alt_names                = []
  $hiera_eyaml_version          = 'installed'
  $puppet_version               = 'installed'
  $puppet_provider              = undef
  $r10k_version                 = 'installed'
  $environmentpath              = '/etc/puppet/environments'
  $module_path                  = undef
  $pre_module_path              = undef
  $future_parser                = false
  $autosign                     = false
  $env_owner                    = 'puppet'
  $eyaml_keys                   = false
  $hiera_backends               = {
    'yaml' => {
      'datadir' => '/etc/puppet/hiera/%{environment}',
    }
  }
  $hieradata_path               = '/etc/puppet/hiera'
  $hiera_hierarchy              = [
    'node/%{::clientcert}',
    'env/%{::environment}',
    'global']
  $passenger_max_pool_size      = '12'
  $passenger_max_requests       = '0'
  $passenger_pool_idle_time     = '1500'
  $passenger_stat_throttle_rate = '120'
  $puppet_fqdn                  = $::fqdn
  $puppet_server                = $::fqdn

  # puppet::master::modules
  $extra_env_repos              = undef
  $hiera_repo                   = undef
  $puppet_env_repo              = undef
  $r10k_env_basedir             = '/etc/puppet/r10kenv'
  $r10k_minutes                 = [ 0, 15, 30, 45]
  $r10k_purgedirs               = true
  $r10k_update                  = true
}
