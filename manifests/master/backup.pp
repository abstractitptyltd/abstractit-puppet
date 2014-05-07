## class puppet::master::backup
# backup important files for puppet::master

class puppet::master::backup (
) inherits puppet::params {

  backup::job { '/etc/puppet/hieradata':
  }

  backup::job { '/etc/puppet/keys':
  }

  backup::job { '/etc/puppet/site':
  }

}
