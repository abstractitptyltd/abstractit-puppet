# # class puppet::config
# config for puppet agent

class puppet::config (
) {
  include ::puppet
  $cfacter          = $::puppet::cfacter
  $puppet_server    = $::puppet::puppet_server
  $environment      = $::puppet::environment
  $reports          = $::puppet::reports
  $runinterval      = $::puppet::runinterval
  $structured_facts = $::puppet::structured_facts

  validate_string(
    $environment,
    $puppet_server,
    $runinterval,
    )
  validate_bool($structured_facts)
  $stringify_facts = $structured_facts ? {
    default => true,
    true    => false,
  }

  ini_setting { 'puppet client server':
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'agent',
    setting => 'server',
    value   => $puppet_server,
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

}
