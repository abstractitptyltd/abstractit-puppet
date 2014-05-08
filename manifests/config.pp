## class puppet::config
# config for puppet agent

class puppet::config (
  $server = $puppet::params::server,
  $environment = $puppet::params::environment,
) inherits puppet::params {

  ini_setting { 'puppet client server':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'server',
    value   => $server,
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

  # check our puppet version to see if we need to remove old settings
  if (versioncmp($puppet_version,'3.5') >= 0) {
    $deprecated_settings = 'absent'
  } else {
    $deprecated_settings = 'present'
  }
  # deprecated in puppet 3.5 so remove these settings
  ini_setting { 'template_dir':
    ensure  => $deprecated_settings,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'templatedir',
    value   => '$confdir/templates',
  }

}
