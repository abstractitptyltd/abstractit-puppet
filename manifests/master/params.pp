## Class puppet::master::params
# setting for the puppet master classes

class puppet::master::params (
  $enabled = $puppet::params::enabled,
  $puppet_env_repo,
  $puppet_upstream_env_repo,
  $hiera_repo,
  $puppetdb_version,
  $r10k_version,
  $gpgme_version,
  $hiera_eyaml_version,
  $hiera_gpg_version,
  $git_protocol = 'ssh',
  $puppet_version = $puppet::params::puppet_version,
  $server = $puppet::params::server,
  $environment = $puppet::params::environment,
  $dumptype = $puppet::params::dumptype,
  $devel_repo = $puppet::params::devel_repo,
  $host = $puppet::params::host,
  $autosign = false,
  $reports = true,
  $node_ttl = '0s',
  $node_purge_ttl = '0s',
  $report_ttl = '14d',
  $unresponsive = '2',
  $environmentpath = '/etc/puppet/r10kenv/local',
  $r10k_env_basedir = '/etc/puppet/r10kenv',
  $hieradata_path = '/etc/puppet/hiera',
  $hiera_eyaml_path = '/etc/puppet/hiera/%{environment}',
  $hiera_yaml_path = '/etc/puppet/hiera/%{environment}',
  $hiera_gpg_path = '/etc/puppet/hiera/%{environment}',
  $pre_module_path = '',
  $module_path = '',
  $manifest_dir = '',
  $manifest = '',
  $r10k_update = true,
  $r10k_minutes = [0,15,30,45],
  $cron_minutes = '0,15,30,45',
  $env_owner = 'puppet',
  $eyaml = true,
  $future_parser = false,
  $puppetdb = true,
  $puppetboard = true,
  $puppetboard_revision = undef,
  $passenger_max_pool_size = '12',
  $passenger_pool_idle_time = '1500',
  $passenger_stat_throttle_rate = '120',
  $passenger_max_requests = '0',
) inherits puppet::params {

  $pre_module_path_real = $pre_module_path ? {
    ''       => '',
    /\w+\:$/ => $pre_module_path,
    default  => "${pre_module_path}:"
  }
  $real_module_path = $module_path ? {
    ''      => "${pre_module_path_real}${::settings::confdir}/site:/usr/share/puppet/modules",
    default => "${pre_module_path_real}${module_path}",
  }
  $real_manifest = $manifest ? {
    ''      => "${r10k_env_basedir}/local/\$environment/manifests/site.pp",
    default => $manifest,
  }
  $real_manifest_dir = $manifest_dir ? {
    ''      => "${r10k_env_basedir}/local/\$environment/manifests",
    default => $manifest_dir,
  }

}
