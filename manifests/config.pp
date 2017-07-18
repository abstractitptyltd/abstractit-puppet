# # class puppet::config
# config for puppet agent

class puppet::config {
  include ::puppet
  include ::puppet::defaults
  $confdir                        = $::puppet::defaults::confdir
  $codedir                        = $::puppet::defaults::codedir
  $sysconfigdir                   = $::puppet::defaults::sysconfigdir
  $ca_server                      = $::puppet::ca_server
  $ca_port                        = $::puppet::ca_port
  $cfacter                        = $::puppet::cfacter
  $environment                    = $::puppet::environment
  $logdest                        = $::puppet::logdest
  $preferred_serialization_format = $::puppet::preferred_serialization_format
  $puppet_server                  = $::puppet::puppet_server
  $reports                        = $::puppet::reports
  $runinterval                    = $::puppet::runinterval
  $show_diff                      = $::puppet::show_diff
  $splay                          = $::puppet::splay
  $splaylimit                     = $::puppet::splaylimit
  $structured_facts               = $::puppet::structured_facts
  $manage_etc_facter              = $::puppet::manage_etc_facter
  $manage_etc_facter_facts_d      = $::puppet::manage_etc_facter_facts_d
  $use_srv_records                = $::puppet::use_srv_records
  $srv_domain                     = $::puppet::srv_domain
  $pluginsource                   = $::puppet::pluginsource
  $pluginfactsource               = $::puppet::pluginfactsource

  $stringify_facts = $structured_facts ? {
    default => true,
    true    => false,
  }
  $logdest_ensure = $logdest ? {
    default => present,
    undef   => absent,
  }
  $splaylimit_ensure = $splaylimit ? {
    default => present,
    undef   => absent,
  }

  if ($use_srv_records) {
    $_ensure_puppet_server = 'absent'
    $_ensure_use_srv_records = 'present'
    $_ensure_srv_domain = 'present'
  } else {
    $_ensure_puppet_server = 'present'
    $_ensure_use_srv_records = 'absent'
    $_ensure_srv_domain = 'absent'
  }

  if ($ca_server) {
    $_ensure_ca_server = 'present'
  } else {
    $_ensure_ca_server = 'absent'
  }

  if ($ca_port) {
    $_ensure_ca_port = 'present'
  } else {
    $_ensure_ca_port = 'absent'
  }

  if ($pluginsource) {
    $_ensure_pluginsource = 'present'
  } else {
    $_ensure_pluginsource = 'absent'
  }

  if ($pluginfactsource) {
    $_ensure_pluginfactsource = 'present'
  } else {
    $_ensure_pluginfactsource = 'absent'
  }

  ini_setting { 'puppet client server agent':
    ensure  => absent,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'server',
    value   => $puppet_server,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client server':
    ensure  => $_ensure_puppet_server,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'server',
    value   => $puppet_server,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet use_srv_records':
    ensure  => $_ensure_use_srv_records,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'use_srv_records',
    value   => $use_srv_records,
  }

  ini_setting { 'puppet srv_domain':
    ensure  => $_ensure_srv_domain,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'srv_domain',
    value   => $srv_domain,
  }

  ini_setting { 'puppet pluginsource':
    ensure  => $_ensure_pluginsource,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'pluginsource',
    value   => $pluginsource,
  }

  ini_setting { 'puppet pluginfactsource':
    ensure  => $_ensure_pluginfactsource,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'pluginfactsource',
    value   => $pluginfactsource,
  }

  ini_setting { 'puppet ca_server':
    ensure  => $_ensure_ca_server,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'ca_server',
    value   => $ca_server,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet ca_port':
    ensure  => $_ensure_ca_port,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'ca_port',
    value   => $ca_port,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client cfacter':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'cfacter',
    value   => $cfacter,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client environment':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'environment',
    value   => $environment,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client runinterval':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'runinterval',
    value   => $runinterval,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client show_diff':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'show_diff',
    value   => $show_diff,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client splay':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'splay',
    value   => $splay,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client splaylimit':
    ensure  => $splaylimit_ensure,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'splaylimit',
    value   => $splaylimit,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet preferred_serialization_format':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'preferred_serialization_format',
    value   => $preferred_serialization_format,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client reports':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'reports',
    value   => $reports,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client structured_facts':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    setting => 'stringify_facts',
    value   => $stringify_facts,
    require => Class['puppet::install'],
  }

  ini_subsetting { 'puppet sysconfig logdest':
    ensure            => $logdest_ensure,
    section           => '',
    key_val_separator => '=',
    path              => "${sysconfigdir}/puppet",
    setting           => 'DAEMON_OPTS',
    subsetting        => '--logdest',
    value             => $logdest
  }
}
