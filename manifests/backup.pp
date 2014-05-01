## class puppet::backup
# backup /var/lib/puppet

class puppet::backup (
  $dumptype = $puppet::params::dumptype,
) inherits puppet::params {

  amanda::disklist::dle { '/var/lib/puppet':
    configs   => ['daily'],
    dumptype  => $dumptype,
  }

}
