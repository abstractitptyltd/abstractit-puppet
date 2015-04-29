class puppet::profile::r10k (
  $remote                    = undef,
  $sources                   = undef,
  $purgedirs                 = true,
  $cachedir                  = undef,
  $configfile                = undef,
  $version                   = undef,
  $modulepath                = undef,
  $manage_module_path        = false,
  $manage_ruby_dependency    = false,
  $r10k_basedir              = undef,
  $mcollective               = false,
  $manage_configfile_symlink = false,
  $configfile_symlink        = undef,
  $include_prerun_command    = false,
  $env_owner                 = 'root',
  $r10k_minutes              = [
    0,
    15,
    30,
    45],
  $r10k_update               = true,
) {

  if ( versioncmp($::puppetversion, '4.0.0') >= 0 ) {
    $r10k_basedir = $::settings::codedir
  } else {
    $r10k_basedir = '/etc/puppet'
  }

  case $r10k_update {
    default: {
      $r10k_cron_ensure = present
    }
    false: {
      $r10k_cron_ensure = absent
    }
  }

  class { '::r10k':
    version                   => $version,
    remote                    => $remote,
    sources                   => $sources,
    r10k_basedir              => $r10k_basedir,
    purgedirs                 => $purgedirs,
    cachedir                  => $cachedir,
    configfile                => $configfile,
    mcollective               => $mcollective,
    manage_configfile_symlink => $manage_configfile_symlink,
    configfile_symlink        => $configfile_symlink,
    include_prerun_command    => $include_prerun_command,
  }

  # cron for updating the r10k environment
  cron { 'puppet_r10k':
    ensure      => $r10k_cron_ensure,
    command     => '/usr/local/bin/r10k deploy environment production -p',
    environment => 'PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin',
    user        => $env_owner,
    minute      => $r10k_minutes
  }
}
