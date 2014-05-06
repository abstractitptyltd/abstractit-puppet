## Class puppet::params
# setting for the puppet module

class puppet::params (
  $enabled = true,
  $puppet_version,
  $puppetdb_version,
  $hiera_version,
  $facter_version,
  $r10k_version,
  $gpgme_version,
  $hiera_gpg_version,
  $server = 'puppet',
  $environment = 'production',
  $autosign = false,
  $dumptype = 'root-tar',
  $puppet_env_repo = 'https://bitbucket.org/pivitptyltd/puppet-environments',
  $puppet_upstream_env_repo = 'https://bitbucket.org/pivitptyltd/puppet-env-upstream',
  $hiera_repo = 'https://bitbucket.org/pivitptyltd/puppet-hieradata',
  $host = $::servername,
  $node_ttl = '0s',
  $node_purge_ttl = '0s',
  $report_ttl = '14d',
  $reports = true,
  $unresponsive = '2',
  $environmentpath = '/etc/puppet/env/local:/etc/puppet/env/upstream',
  $r10k_env_basedir = '/etc/puppet/env',
  $hieradata_path = '/etc/puppet/hiera',
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
  $gpg = true,
  $future_parser = false,
  $puppetdb = true,
  $puppetboard = true,
  $puppetboard_revision = undef,
  $passenger_max_pool_size = '12',
  $passenger_pool_idle_time = '1500',
  $passenger_stat_throttle_rate = '120',
  $passenger_max_requests = '0',
) {

  $pre_module_path_real = $pre_module_path ? {
    ''       => '',
    /\w+\:$/ => $pre_module_path,
    default  => "${pre_module_path}:"
  }

  $real_module_path = $module_path ? {
    ''      => "${::settings::confdir}/site:/etc/puppet/modules:/usr/share/puppet/modules",
    default => $module_path,
  }
  $real_manifest = $manifest ? {
    ''      => "${r10k_env_basedir}/\$environment/manifests/site.pp",
    default => $manifest,
  }
  $real_manifest_dir = $manifest_dir ? {
    ''      => "${r10k_env_basedir}/\$environment/manifests",
    default => $manifest_dir,
  }

}
