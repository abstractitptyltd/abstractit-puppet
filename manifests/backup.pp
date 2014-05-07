## class puppet::backup
# backup /var/lib/puppet

class puppet::backup (
) inherits puppet::params {

  backup::job { '/var/lib/puppet':
  }

}
