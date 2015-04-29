class puppet::master (
  $basemodulepath               = $::puppet::defaults::basemodulepath,
  $environmentpath              = $::puppet::defaults::environmentpath,
  $hieradata_path               = $::puppet::defaults::hieradata_path,
  $hiera_hierarchy              = [
    'node/%{::clientcert}',
    'env/%{::environment}',
    'global'],
  $autosign                     = false,
  $eyaml_keys                   = false,
  $future_parser                = false,
  $java_ram                     = '2g',
  $hiera_backends               = $::puppet::defaults::hiera_backends,
  $server_type                  = $::puppet::defaults::server_type,
  $server_version               = 'installed',
  $hiera_eyaml_version          = 'installed',
  $puppet_version               = 'installed',
  $env_owner                    = 'puppet',
  $puppet_server                = $::fqdn,
  $r10k_version                 = undef,
  $passenger_max_pool_size      = '12',
  $passenger_max_requests       = '0',
  $passenger_pool_idle_time     = '1500',
  $passenger_stat_throttle_rate = '120',
  $puppet_fqdn                  = $::fqdn,
  $module_path                  = undef,
  $pre_module_path              = undef,
) inherits ::puppet::defaults {

  #input validation
  validate_absolute_path(
    $environmentpath,
    $hieradata_path,
  )
  validate_array(
    $hiera_hierarchy,
  )

  validate_bool(
    $autosign,
    $eyaml_keys,
    $future_parser,
  )

  validate_hash(
    $hiera_backends
  )

  validate_string(
    $env_owner,
    $hiera_eyaml_version,
    $puppet_fqdn,
    $puppet_server,
    $puppet_version,
    $server_version,
    $passenger_max_pool_size,
    $passenger_max_requests,
    $passenger_pool_idle_time,
    $passenger_stat_throttle_rate,
  )

  # add deprecation warnings
  if $r10k_version != undef {
    notify { 'Deprecation notice: puppet::master::r10k_version is deprecated, use puppet::profile::r10k class instead': }
  }
  if $module_path != undef {
    notify { 'Deprecation notice: puppet::master::module_path is deprecated, use puppet::master::basemodulepath instead': }
  }
  if $pre_module_path != undef {
    notify { 'Deprecation notice: puppet::master::pre_module_path is deprecated, use puppet::master::basemodulepath instead': }
  }

  include ::puppet::master::install
  include ::puppet::master::config
  include ::puppet::master::hiera

  case $server_type {
    'puppetserver': {
      include ::puppet::master::server
      # Class['puppet::master::hiera'] ~>
      # Class['puppet::master::server']
    }
    default: {
      include ::puppet::master::passenger
      # Class['puppet::master::hiera'] ~>
      # Class['puppet::master::passenger']
    }
  }

  Class['puppet::master::install'] ->
  Class['puppet::master::config'] ->
  Class['puppet::master::hiera']

}
