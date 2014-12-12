# # puppet agent service

class puppet::agent (){
  include ::puppet
  if $::puppet::enabled {
    #we want puppet enabled
    case $::puppet::enable_mechanism {
      'service': {
        #we want puppet enabled as a service
        $cron_enablement     = 'absent'
        $service_enablement  = true
        $default_start_value = 'yes'
      }
      'cron': {
        $cron_enablement     = 'present'
        $service_enablement  = false
        $default_start_value = 'no'
      }
      default: {
        #noop. should never happen.
      }
    }

  } else {
    #$::puppet::enabled is false
    $cron_enablement    = 'absent'
    $service_enablement = false
    $default_start_value = 'no'
  }

  ini_setting { 'puppet_defaults':
    ensure  => present,
    path    => '/etc/default/puppet',
    section => '',
    setting => 'START',
    value   => $default_start_value,
  }

  cron {"run_puppet_agent":
    ensure  => $cron_enablement,
    command => 'puppet agent -t',
    special => 'absent',
    minute  => $::puppet::agent_cron_min_interpolated,
    hour    => $::puppet::agent_cron_hour_interpolated,
  }

  service { 'puppet':
    ensure  => $service_enablement,
    enable  => $service_enablement,
    require => Class['puppet::config']
  }

}
