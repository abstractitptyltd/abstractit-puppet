# # Class puppet::master::config.pp

class puppet::master::config {
  include ::puppet::master
  include ::puppet::defaults
  $confdir              = $::puppet::defaults::confdir
  $codedir              = $::puppet::defaults::codedir
  $reports_dir          = $::puppet::defaults::reports_dir
  $ca_server            = $::puppet::ca_server
  $environmentpath      = $puppet::master::environmentpath
  $environment_timeout  = $puppet::master::environment_timeout
  $basemodulepath       = $puppet::master::basemodulepath
  $future_parser        = $puppet::master::future_parser
  $autosign             = $puppet::master::autosign
  $report_age           = $puppet::master::report_age
  $report_clean_hour    = $puppet::master::report_clean_hour
  $report_clean_min     = $puppet::master::report_clean_min
  $report_clean_weekday = $puppet::master::report_clean_weekday

  if ($ca_server != undef) {
    if ($ca_server == $::fqdn) {
      ini_setting { 'puppet CA':
        ensure  => present,
        path    => "${confdir}/puppet.conf",
        section => 'master',
        setting => 'ca',
        value   => true,
      }
    } else {
      ini_setting { 'puppet CA':
        ensure  => present,
        path    => "${confdir}/puppet.conf",
        section => 'master',
        setting => 'ca',
        value   => false,
      }
    }
  }

  ini_setting { 'Puppet environmentpath':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'environmentpath',
    value   => $environmentpath
  }

  ini_setting { 'Puppet basemodulepath':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'basemodulepath',
    value   => $basemodulepath
  }

  ini_setting { 'Puppet environment_timeout':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'environment_timeout',
    value   => $environment_timeout
  }

  # cleanup old puppet reports
  cron { 'puppet clean reports':
    command => "cd ${reports_dir} && find . -type f -name \\*.yaml -mtime +${report_age} -print0 | xargs -0 -n50 /bin/rm -f",
    user    => root,
    hour    => $report_clean_hour,
    minute  => $report_clean_min,
    weekday => $report_clean_weekday,
  }

  if ($autosign == true and $::environment != 'production') {
    # enable autosign
    ini_setting { 'autosign':
      ensure  => present,
      path    => "${confdir}/puppet.conf",
      section => 'master',
      setting => 'autosign',
      value   => true
    }
  } else {
    # disable autosign
    ini_setting { 'autosign':
      ensure  => absent,
      path    => "${confdir}/puppet.conf",
      section => 'master',
      setting => 'autosign',
      value   => true
    }
  }

  if $future_parser {
    # enable future parser
    ini_setting { 'master parser':
      ensure  => present,
      path    => "${confdir}/puppet.conf",
      section => 'master',
      setting => 'parser',
      value   => 'future'
    }
  } else {
    # disable future parser
    ini_setting { 'master parser':
      ensure  => absent,
      path    => "${confdir}/puppet.conf",
      section => 'master',
      setting => 'parser',
      value   => 'future'
    }
  }

}
