# # puppet agent service

class puppet::agent {
  include ::puppet
  include ::puppet::defaults

  $sysconfigdir     = $::puppet::defaults::sysconfigdir

  if ( versioncmp($::puppetversion, '4.0.0') >= 0 ) {
    $bin_dir = '/opt/puppetlabs/bin'
  } else {
    $bin_dir = '/usr/bin'
  }

  if $::puppet::enabled {
    #we want puppet enabled
    case $::puppet::enable_mechanism {
      'service': {
        #we want puppet enabled as a service
        $cron_enablement    = 'absent'
        $service_enablement = true
        $start_enablement   = 'yes'
      }
      'cron': {
        $cron_enablement    = 'present'
        $service_enablement = false
        $start_enablement   = 'no'
      }
      default: {
        #noop. should never happen.
      }
    }

  } else {
    #$::puppet::enabled is false
    $cron_enablement    = 'absent'
    $service_enablement = false
    $start_enablement   = 'no'
  }

  cron {'run_puppet_agent':
    ensure  => $cron_enablement,
    command => "${bin_dir}/puppet agent --no-daemonize --onetime",
    special => 'absent',
    minute  => $::puppet::agent_cron_min_interpolated,
    hour    => $::puppet::agent_cron_hour_interpolated,
  }

  service { 'puppet':
    ensure  => $service_enablement,
    enable  => $service_enablement,
    require => Class['puppet::config']
  }

  if $::osfamily =='Debian' {
    ini_setting { 'puppet sysconfig start':
      ensure            => 'present',
      section           => '',
      key_val_separator => '=',
      path              => "${sysconfigdir}/puppet",
      setting           => 'START',
      value             => $start_enablement
    }
  }

}
