# # Class puppet::master::config.pp

class puppet::master::config (
  $environmentpath   = $puppet::master::params::environmentpath,
  $extra_module_path = $puppet::master::extra_module_path,
  $future_parser     = $puppet::master::params::future_parser,
  $autosign          = $puppet::master::params::autosign,
) inherits puppet::master::params {
validate_absolute_path($environmentpath)

validate_bool(
  $autosign,
  $future_parser,
  )
validate_string($extra_module_path)

  ini_setting { 'Puppet environmentpath':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'environmentpath',
    value   => $environmentpath
  }

  ini_setting { 'Puppet basemodulepath':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'basemodulepath',
    value   => $extra_module_path
  }

  if ($autosign == true and $::environment != 'production') {
    # enable autosign
    ini_setting { 'autosign':
      ensure  => present,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'autosign',
      value   => true
    }
  } else {
    # disable autosign
    ini_setting { 'autosign':
      ensure  => absent,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'autosign',
      value   => true
    }
  }

  if $future_parser {
    # enable future parser
    ini_setting { 'master parser':
      ensure  => present,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'parser',
      value   => 'future'
    }
  } else {
    # disable future parser
    ini_setting { 'master parser':
      ensure  => absent,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'parser',
      value   => 'future'
    }
  }

}
