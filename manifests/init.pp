class puppet (
  $agent_cron_hour           = '*',
  $agent_cron_min            = 'two_times_an_hour',
  $devel_repo                = false,
  $enabled                   = true,
  $enable_devel_repo         = false,
  $enable_mechanism          = 'service',
  $enable_repo               = true,
  $environment               = 'production',
  $facter_version            = 'installed',
  $hiera_version             = 'installed',
  $manage_etc_facter         = true,
  $manage_etc_facter_facts_d = true,
  $manage_repos              = true,
  $puppet_server             = 'puppet',
  $puppet_version            = 'installed',
  $reports                   = true,
  $runinterval               = '30m',
  $structured_facts          = false,
  $custom_facts              = undef,
) {
  #input validation
  validate_bool(
    $devel_repo,
    $enabled,
    $enable_repo,
    $manage_etc_facter,
    $manage_etc_facter_facts_d,
    $manage_repos,
    $reports,
    $structured_facts,
  )

  validate_string(
    $environment,
    $facter_version,
    $hiera_version,
    $puppet_server,
    $puppet_version,
    $runinterval,
  )
  $supported_mechanisms = ['service', 'cron']
  validate_re($enable_mechanism, $supported_mechanisms)

  if $enable_mechanism == 'cron' {
    #no point in generating this unless we're using it
    case $agent_cron_min {
      #provide a co
      'two_times_an_hour': {
        $min=fqdn_rand(29)
        $min_2=$min + 30
        $agent_cron_min_interpolated = [ $min, $min_2 ]
      }
    'four_times_an_hour': {
        $min=fqdn_rand(14)
        $min_2=$min + 15
        $min_3=$min + 30
        $min_4=$min + 45
        $agent_cron_min_interpolated = [$min, $min_2, $min_3, $min_4 ]
      }
      default: {
        #the variable is populated. feed that to the cronjob
        $agent_cron_min_interpolated = $agent_cron_min
      }
    }
    #tooling in case we want to provide similar human_readable behaviors to
    #cron_hour
    $agent_cron_hour_interpolated = $agent_cron_hour
  }
  $enable = $enabled ? {
    default => true,
    false   => false,
  }

  if $manage_repos {
    #only manage this if we're managing repos
    if $devel_repo {
      $enable_devel_repo_interpolated = true
    } else {
      if $enable_devel_repo {
        $enable_devel_repo_interpolated = true
      } else {
        $enable_devel_repo_interpolated = false
      }
    }
    include ::puppet::repo
    Class['::puppet::repo'] -> Class['::puppet::install']
  }
  if $custom_facts {
    class { 'puppet::facts':
      custom_facts => $custom_facts,
    }
  }
  include ::puppet::install
  include ::puppet::config
  include ::puppet::agent

  Class['puppet::install'] ->
  Class['puppet::config'] ~>
  Class['puppet::agent']

}
