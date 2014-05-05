## class puppet::master::backup
# backup important files for puppet::master

class puppet::master::backup (
  $dumptype = $puppet::params::dumptype,
) inherits puppet::params {

  amanda::disklist::dle { '/etc/puppet/hieradata':
    configs   => ['daily'],
    dumptype  => $dumptype,
  }

  amanda::disklist::dle { '/etc/puppet/keys':
    configs   => ['daily'],
    dumptype  => $dumptype,
  }

  amanda::disklist::dle { '/etc/puppet/site':
    configs   => ['daily'],
    dumptype  => $dumptype,
  }

}
