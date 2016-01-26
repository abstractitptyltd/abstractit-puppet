# setup the puppetlabs apt repo

class puppet::repo::apt {
  include ::puppet
  if $::puppet::manage_repos {
    #we only do anything if we're managing repos.
    include ::apt
    if $::puppet::enable_repo {
      $source_ensure = 'present'
    } else {
      $source_ensure = 'absent'
    }
    if $::puppet::enable_devel_repo {
      $devel_ensure = 'present'
    } else {
      $devel_ensure = 'absent'
    }

    if $::puppet::collection != undef {
      $lc_collection_name = downcase($::puppet::collection)
      apt::source { "puppetlabs-${lc_collection_name}":
        ensure     => 'present',
        location   => 'http://apt.puppetlabs.com',
        repos      => $::puppet::collection,
        key        => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
        key_server => 'pgp.mit.edu',
      }
    } else {
      apt::source { 'puppetlabs':
        ensure     => $source_ensure,
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main dependencies',
        key        => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
        key_server => 'pgp.mit.edu',
      }
      apt::source { 'puppetlabs_devel':
        ensure     => $devel_ensure,
        location   => 'http://apt.puppetlabs.com',
        repos      => 'devel',
        key        => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
        key_server => 'pgp.mit.edu',
      }
    }

  }#manage_repos

}
