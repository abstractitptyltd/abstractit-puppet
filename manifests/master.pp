class puppet::master (
  $puppet_env_repo = 'https://bitbucket.org/pivitptyltd/puppet-environments',
  $hiera_repo = 'https://bitbucket.org/pivitptyltd/puppet-hieradata',
  $host = $::servername,
  $node_ttl = '0s',
  $node_purge_ttl = '0s',
  $report_ttl = '14d',
  $reports = true,
  $unresponsive = '2',
  $env_basedir = '/etc/puppet/environments',
  $hieradata_path = '/etc/puppet/hiera',
  $hiera_yaml_path = '/etc/puppet/hiera/%{environment}',
  $hiera_gpg_path = '/etc/puppet/hiera/%{environment}',
  $pre_module_path = '',
  $module_path = '',
  $manifest_dir = '',
  $manifest = '',
  $r10k_update = true,
  $cron_minutes = '0,15,30,45',
  $env_owner = 'puppet',
  $gpg = true,
  $future_parser = false,
  $puppetboard_revision = undef,
  $passenger_max_pool_size = '12',
  $passenger_pool_idle_time = '1500',
  $passenger_stat_throttle_rate = '120',
  $passenger_max_requests = '0',
) {

  include apache
  include site::monit::apache

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
    ''      => "${env_basedir}/\$environment/manifests/site.pp",
    default => $manifest,
  }
  $real_manifest_dir = $manifest_dir ? {
    ''      => "${env_basedir}/\$environment/manifests",
    default => $manifest_dir,
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
  }

  # r10k setup
  package { 'r10k':
    ensure   => '1.2.0',
    provider => gem,
  }
  file { '/var/cache/r10k':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0700',
  }
  file { '/etc/r10k.yaml':
    ensure  => file,
    content => template('puppet/r10k.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  ini_setting { 'Puppet environmentpath':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'environmentpath',
    value   => $env_basedir,
  }

  ini_setting { 'Puppet basemodulepath':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'basemodulepath',
    value   => $real_module_path,
  }

  # unnecessicary in puppet 3.5 so remove these settings
  ini_setting { 'R10k master manifest':
    ensure  => absent,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'master',
    setting => 'manifest',
    value   => $real_manifest,
  }
  ini_setting { 'R10k master manifestdir':
    ensure  => absent,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'master',
    setting => 'manifestdir',
    value   => $real_manifest_dir,
  }
  ini_setting { 'R10k master modules':
    ensure  => absent,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'master',
    setting => 'modulepath',
    value   => $real_module_path,
  }

  ini_setting { 'R10k user modules':
    ensure  => absent,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'user',
    setting => 'modulepath',
    value   => $real_module_path,
  }

  file { $env_basedir:
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0755',
  }
  # cron for updating the r10k environment
  # will possibly link thins to a git commit hook at some point
  cron_job { 'puppet_r10k':
    enable   => $r10k_update,
    interval => 'd',
    script   => "# created by puppet
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
${cron_minutes} * * * * ${env_owner} /usr/local/bin/r10k deploy environment production
",
  }

  ## setup hiera
  package { 'gpgme':
    ensure   => '2.0.2',
    provider => gem,
  }

  package { 'hiera-gpg':
    ensure   => '1.1.0',
    provider => gem,
  }

  file { '/etc/puppet/keys':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0700',
  }
  file { $hieradata_path:
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0755',
  }

  file { '/etc/hiera.yaml':
    ensure  => file,
    content => template('puppet/hiera.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Vcsrepo['/etc/puppet/hieradata'],
  }
  file { '/etc/puppet/hiera.yaml':
    ensure   => link,
    target   => '/etc/hiera.yaml',
    require  => File['/etc/hiera.yaml'],
  }

  vcsrepo { '/etc/puppet/hieradata':
    ensure   => latest,
    revision => 'production',
    provider => git,
    owner    => puppet,
    group    => puppet,
    source   => 'https://bitbucket.org/pivitptyltd/puppet-hieradata',
  }

  # setup puppetdb
  class { 'puppetdb':
    ssl_listen_address => '0.0.0.0',
    node_ttl           => $node_ttl,
    node_purge_ttl     => $node_purge_ttl,
    report_ttl         => $report_ttl,
  }
  class { 'puppetdb::master::config':
    puppet_service_name     => 'httpd',
    puppetdb_server         => $host,
    enable_reports          => $reports,
    manage_report_processor => $reports,
    restart_puppet          => false,
  }

  # disabling for now.
  # python class seems broken in puppet 3.5
  ## setup puppetboard
  class { 'python':
    version    => 'system',
    dev        => true,
    pip        => true,
    virtualenv => true,
  }
  class { 'apache::mod::wsgi':
  }
  class { 'puppetboard':
    unresponsive => $unresponsive,
    revision     => $puppetboard_revision,
  }
  class { 'puppetboard::apache::vhost':
    vhost_name => 'pboard',
  }

  # passenger settings
  class { 'apache::mod::passenger':
    passenger_high_performance   => 'On',
    passenger_max_pool_size      => $passenger_max_pool_size,
    passenger_pool_idle_time     => $passenger_pool_idle_time,
    passenger_stat_throttle_rate => $passenger_stat_throttle_rate,
    passenger_max_requests       => $passenger_max_requests,
    rack_autodetect              => 'Off',
    rails_autodetect             => 'Off',
  }

  package { 'puppetmaster-passenger':
    ensure => installed
  }

  ## puppetmaster vhost in apache
  apache::vhost{ 'puppetmaster':
    docroot           => '/usr/share/puppet/rack/puppetmasterd/public/',
    docroot_owner     => 'root',
    docroot_group     => 'root',
    port              => '8140',
    ssl               => true,
    ssl_protocol      => '-ALL +SSLv3 +TLSv1',
    ssl_cipher        => 'ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP',
    ssl_cert          => "/var/lib/puppet/ssl/certs/${host}.pem",
    ssl_key           => "/var/lib/puppet/ssl/private_keys/${host}.pem",
    ssl_chain         => '/var/lib/puppet/ssl/certs/ca.pem',
    ssl_ca            => '/var/lib/puppet/ssl/certs/ca.pem',
    ssl_crl           => '/var/lib/puppet/ssl/ca/ca_crl.pem',
    ssl_certs_dir     => undef,
    ssl_verify_client => 'optional',
    ssl_verify_depth  => '1',
    ssl_options       => ['+StdEnvVars','+ExportCertData'],
    rack_base_uris    => ['/'],
    directories       => [
      { path          => '/usr/share/puppet/rack/puppetmasterd/',
        options       => 'None',
        order         => 'allow,deny',
        allow         => 'from all',
      }
    ],
    request_headers   => [
      'unset X-Forwarded-For',
      'set X-SSL-Subject %{SSL_CLIENT_S_DN}e',
      'set X-Client-DN %{SSL_CLIENT_S_DN}e',
      'set X-Client-Verify %{SSL_CLIENT_VERIFY}e',
    ],
  }

  # cleanup old puppet reports
  cron { "puppet clean reports":
    command => 'cd /var/lib/puppet/reports && find . -type f -name \*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f',
    user => root,
    hour => 21,
    minute => 22,
    weekday => 0,
  }

}
