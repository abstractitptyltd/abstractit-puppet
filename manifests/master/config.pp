# # Class puppet::master::config.pp

class puppet::master::config (
  $autosign          = $puppet::master::env::autosign,
  $dns_alt_names     = $puppet::master::env::dns_alt_names,
  $environmentpath   = $puppet::master::env::environmentpath,
  $extra_module_path = $puppet::master::env::extra_module_path,
  $future_parser     = $puppet::master::env::future_parser,
  $puppet_fqdn       = $puppet::master::env::puppet_fqdn,
) inherits puppet::master::env {

  validate_absolute_path($environmentpath)
  validate_bool($future_parser)
  validate_string(
    $extra_module_path,
    $puppet_fqdn
  )
  validate_array($dns_alt_names)

  if !(is_bool($autosign) or is_string($autosign)) {
    fail("Expect $autosign to be either a bool or a string: ${::autosign}")
  }

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

  ini_setting { 'certname':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'certname',
    value   => $puppet_fqdn,
  }

  ini_setting { 'autosign':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'master',
    setting => 'autosign',
    value   => $autosign,
  }

  if $dns_alt_names {
    ini_setting { 'dns_alt_names':
      ensure  => present,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'dns_alt_names',
      value   => join($dns_alt_names, ', '),
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
