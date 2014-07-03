# # class puppet::config
# config for puppet agent

class puppet::config (
  $puppet_server    = $puppet::params::puppet_server,
  $environment      = $puppet::params::environment,
  $structured_facts = false) inherits puppet::params {
  $stringify_facts = $structured_facts ? {
    default => true,
    true    => false,
  }

  ini_setting { 'puppet client server':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'server',
    value   => $puppet_server,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client environment':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'environment',
    value   => $environment,
    require => Class['puppet::install'],
  }

  ini_setting { 'puppet client structured_facts':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'stringify_facts',
    value   => $stringify_facts,
    require => Class['puppet::install'],
  }

}
