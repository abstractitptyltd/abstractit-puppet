# # class puppet::config
# config for puppet agent

class puppet::config {
  include ::puppet
  include ::puppet::defaults
  $confdir                        = $::puppet::defaults::confdir
  $codedir                        = $::puppet::defaults::codedir
  $sysconfigdir                   = $::puppet::defaults::sysconfigdir
  $ca_server                      = $::puppet::ca_server
  $cfacter                        = $::puppet::cfacter
  $environment                    = $::puppet::environment
  $logdest                        = $::puppet::logdest
  $preferred_serialization_format = $::puppet::preferred_serialization_format
  $puppet_server                  = $::puppet::puppet_server
  $reports                        = $::puppet::reports
  $runinterval                    = $::puppet::runinterval
  $structured_facts               = $::puppet::structured_facts
  $manage_etc_facter              = $::puppet::manage_etc_facter
  $manage_etc_facter_facts_d      = $::puppet::manage_etc_facter_facts_d

  $stringify_facts = $structured_facts ? {
    default => true,
    true    => false,
  }
  $logdest_ensure = $logdest ? {
    default => present,
    undef   => absent,
  }

  ini_setting { 'puppet client server':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'server',
    value   => $puppet_server,
    require => Class['puppet::install'],
  }

  if ($ca_server != undef) {
    ini_setting { 'puppet ca_server':
      ensure  => present,
      path    => "${confdir}/puppet.conf",
      section => 'main',
      setting => 'ca_server',
      value   => $ca_server,
      require => Class['puppet::install'],
    }
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
