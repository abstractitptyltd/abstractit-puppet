## Class puppet::master::config.pp

class puppet::master::config (
  $puppet_version = $puppet::master::params::puppet_version,
  $future_parser = $puppet::master::params::future_parser,
  $environmentpath = $puppet::master::params::environmentpath,
  $real_module_path = $puppet::master::params::real_module_path,
  $real_manifest = $puppet::master::params::real_manifest,
  $real_manifest_dir = $puppet::master::params::real_manifest_dir,
  $autosign = $puppet::master::params::autosign,
) inherits puppet::master::params {

  if ( $autosign == true and $::environment != 'production' ) {
    # enable autosign
    ini_setting { 'autosign':
      ensure  => present,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'autosign',
      value   => true,
    }
  } else {
    # disable autosign
    ini_setting { 'autosign':
      ensure  => absent,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'autosign',
      value   => true,
    }
  }

  if $future_parser {
    # enable future parser
    ini_setting { 'master parser':
      ensure  => present,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'parser',
      value   => 'future',
    }
  } else {
    # disable future parser
    ini_setting { 'master parser':
      ensure  => absent,
      path    => "${::settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'parser',
      value   => 'future',
    }
  }

  ini_setting { 'Puppet environmentpath':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'environmentpath',
    value   => $environmentpath,
  }

  ini_setting { 'Puppet basemodulepath':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'basemodulepath',
    value   => $real_module_path,
  }
  # check our puppet version to see if we need to add old setting for dynamic environments
  if (versioncmp($puppet_version,'3.5') >= 0) {
    $r10k_settings = 'absent'
  } else {
    $r10k_settings = 'present'
  }
  # unnecessicary in puppet 3.5 so remove these settings
  ini_setting { 'R10k master manifest':
    ensure  => $r10k_settings,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'master',
    setting => 'manifest',
    value   => $real_manifest,
  }
  ini_setting { 'R10k master manifestdir':
    ensure  => $r10k_settings,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'master',
    setting => 'manifestdir',
    value   => $real_manifest_dir,
  }
  ini_setting { 'R10k master modules':
    ensure  => $r10k_settings,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'master',
    setting => 'modulepath',
    value   => $real_module_path,
  }

  ini_setting { 'R10k user modules':
    ensure  => $r10k_settings,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'user',
    setting => 'modulepath',
    value   => $real_module_path,
  }

}
