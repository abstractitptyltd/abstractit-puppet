class puppet::master (
  $hiera_eyaml_version          = 'installed',
  $puppet_version               = 'installed',
  $r10k_version                 = 'installed',
  $environmentpath              = '/etc/puppet/environments',
  $module_path                  = '',
  $pre_module_path              = '',
  $future_parser                = false,
  $autosign                     = false,
  $env_owner                    = 'puppet',
  $eyaml_keys                   = false,
  $hiera_backends               = {
    'yaml' => {
      'datadir' => '/etc/puppet/hiera/%{environment}',
    }
  },
  $hieradata_path               = '/etc/puppet/hiera',
  $hiera_hierarchy              = [
    'node/%{::clientcert}',
    'env/%{::environment}',
    'global'],
  $passenger_max_pool_size      = '12',
  $passenger_max_requests       = '0',
  $passenger_pool_idle_time     = '1500',
  $passenger_stat_throttle_rate = '120',
  $puppet_fqdn                  = $::fqdn,
  $puppet_server                = $::fqdn,
) {

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
    $passenger_max_pool_size,
    $passenger_max_requests,
    $passenger_pool_idle_time,
    $passenger_stat_throttle_rate,
    $puppet_fqdn,
    $puppet_server,
    $puppet_version,
    $r10k_version,
  )

  if $pre_module_path{
    validate_string($pre_module_path)
  }
  if $module_path{
    validate_string($module_path)
  }

  $pre_module_path_real = $pre_module_path ? {
    ''       => '',
    /\w+\:$/ => $pre_module_path,
    default  => "${pre_module_path}:"
  }
  $extra_module_path    = $module_path ? {
    ''      => "${pre_module_path_real}${::settings::confdir}/site:/usr/share/puppet/modules",
    default => "${pre_module_path_real}${module_path}",
  }

  include puppet::master::install
  include puppet::master::config
  include puppet::master::hiera
  include puppet::master::passenger

  Class['puppet::master::install'] ->
  Class['puppet::master::config'] ->
  Class['puppet::master::hiera'] ~>
  Class['puppet::master::passenger']

}
