class puppet (
  $dumptype = 'root-tar',
) {

  include puppet::params
  $dumptype = $puppet::params::dumptype

  amanda::disklist::dle { '/var/lib/puppet':
    configs   => ['daily'],
    dumptype  => $dumptype,
  }

}
