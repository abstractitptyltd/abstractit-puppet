class puppet (
  $devel_repo                = $puppet::params::devel_repo,
  $enabled                   = true,
  $enable_devel_repo         = false,
  $enable_mechanism          = 'service',
  $enable_repo               = true,
  $environment               = $puppet::params::environment,
  $facter_version            = 'installed',
  $hiera_version             = 'installed',
  $manage_etc_facter         = true,
  $manage_etc_facter_facts_d = true,
  $manage_repos              = true,
  $puppet_server             = $puppet::params::puppet_server,
  $puppet_version            = 'installed',
  $reports                   = $puppet::params::reports,
  $runinterval               = $puppet::params::runinterval,
  $structured_facts          = false,) inherits puppet::params {
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
  include ::puppet::agent
  include ::puppet::facts
  class { 'puppet::install':
    puppet_version => $puppet_version,
    hiera_version  => $hiera_version,
    facter_version => $facter_version,
  } ->
  class { 'puppet::config':
    puppet_server    => $puppet_server,
    environment      => $environment,
    runinterval      => $runinterval,
    structured_facts => $structured_facts,
  } ~>
  Class['puppet::agent']
}
