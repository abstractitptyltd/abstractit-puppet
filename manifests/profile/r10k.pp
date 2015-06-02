# The puppet::profile::r10k class is respinsible for setting up R10K
#
# @puppet::profile::r10k when declaring the puppet::profile::r10k class
#   include puppet::profile::r10k
#
# @param remote [String] Default: undef
# @param sources [String] Default: undef
# @param purgedirs [Boolean] Default: true
# @param cachedir [String] Default: undef
# @param configfile [String] Default: undef
# @param version [String] Default: undef
# @param manage_ruby_dependency [Boolean] Default: false
# @param r10k_basedir [String] Default: undef
# @param mcollective [Boolean] Default: false
# @param manage_configfile_symlink [Boolean] Default: false
# @param configfile_symlink [String] Default: undef
# @param include_prerun_command [Boolean] Default: false
# @param env_owner [String] Default:'root',
# @param r10k_minutes [Array] Default [0,15,30,45]
# @param r10k_update [Boolean] true

class puppet::profile::r10k (
  $remote                    = undef,
  $sources                   = undef,
  $purgedirs                 = true,
  $cachedir                  = undef,
  $configfile                = undef,
  $version                   = undef,
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

  include ::puppet::defaults
  $codedir = $::puppet::defaults::codedir

  $r10k_basedir = "${codedir}/environments"

  case $r10k_update {
    default: {
      $r10k_cron_ensure = present
    }
    false: {
      $r10k_cron_ensure = absent
    }
  }

  class { '::r10k':
    remote                    => $remote,
    sources                   => $sources,
    purgedirs                 => $purgedirs,
    cachedir                  => $cachedir,
    configfile                => $configfile,
    version                   => $version,
    r10k_basedir              => $r10k_basedir,
    mcollective               => $mcollective,
    manage_configfile_symlink => $manage_configfile_symlink,
    configfile_symlink        => $configfile_symlink,
    include_prerun_command    => $include_prerun_command,
  }

  # cron for updating the r10k environment
  cron { 'puppet_r10k':
    ensure      => $r10k_cron_ensure,
    command     => 'r10k deploy environment production -p',
    environment => 'PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin',
    user        => $env_owner,
    minute      => $r10k_minutes
  }
}
