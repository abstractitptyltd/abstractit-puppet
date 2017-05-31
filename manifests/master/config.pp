# # Class puppet::master::config.pp

class puppet::master::config {
  include ::puppet::master
  include ::puppet::defaults
  $confdir              = $::puppet::defaults::confdir
  $codedir              = $::puppet::defaults::codedir
  $reports_dir          = $::puppet::defaults::reports_dir
  $ca_server            = $::puppet::ca_server
  $autosign_method      = $::puppet::master::autosign_method
  $autosign_file        = $::puppet::master::autosign_file
  $autosign_domains     = $::puppet::master::autosign_domains
  $environmentpath      = $puppet::master::environmentpath
  $environment_timeout  = $puppet::master::environment_timeout
  $basemodulepath       = $puppet::master::basemodulepath
  $future_parser        = $puppet::master::future_parser
  $autosign             = $puppet::master::autosign
  $report_age           = $puppet::master::report_age
  $report_clean_hour    = $puppet::master::report_clean_hour
  $report_clean_min     = $puppet::master::report_clean_min
  $report_clean_weekday = $puppet::master::report_clean_weekday
  $external_nodes       = $puppet::master::external_nodes
  $node_terminus        = $puppet::master::node_terminus

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

  # setup autosign and autosign file
  case $autosign_method {
    default,'file': {
      $autosign_value = $autosign_file
    }
    'off': {
      $autosign_value = false
    }
    'on': {
      if $::environment == 'production' {
        $autosign_value = false
      } else {
        $autosign_value = true
      }
    }
  }

  # setup autosign
  ini_setting { 'autosign':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'master',
    setting => 'autosign',
    value   => $autosign_value
  }

  if (! empty($autosign_domains) ) {
    file { $autosign_file:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('puppet/autosign.conf.erb')
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
    command => "if test -x ${reports_dir}; then cd ${reports_dir} && find . -type f -name \\*.yaml -mtime +${report_age} -print0 | xargs -0 -n50 /bin/rm -f; fi",
    user    => root,
    hour    => $report_clean_hour,
    minute  => $report_clean_min,
    weekday => $report_clean_weekday,
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

  if ( $external_nodes != undef and $node_terminus != undef ){
    # enable external_nodes
    ini_setting { 'master external_nodes':
      ensure  => present,
      path    => "${confdir}/puppet.conf",
      section => 'master',
      setting => 'external_nodes',
      value   => $external_nodes,
    }
    ini_setting { 'master node_terminus':
      ensure  => present,
      path    => "${confdir}/puppet.conf",
      section => 'master',
      setting => 'node_terminus',
      value   => $node_terminus,
    }
  } else {
    # disable external_nodes
    ini_setting { 'master external_nodes':
      ensure  => absent,
      path    => "${confdir}/puppet.conf",
      section => 'master',
      setting => 'external_nodes',
    }
    ini_setting { 'master node_terminus':
      ensure  => absent,
      path    => "${confdir}/puppet.conf",
      section => 'master',
      setting => 'node_terminus',
    }
  }

}
