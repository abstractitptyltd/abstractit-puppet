# # Class puppet::master::config.pp

class puppet::master::config {
  include ::puppet::master
  include ::puppet::defaults
  $confdir          = $::puppet::defaults::confdir
  $codedir          = $::puppet::defaults::codedir
  $environmentpath  = $puppet::master::environmentpath
  $basemodulepath   = $puppet::master::basemodulepath
  $future_parser    = $puppet::master::future_parser
  $autosign         = $puppet::master::autosign

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
