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
        key        => {
          'id'     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
          'server' => 'pgp.mit.edu'
        }
      }
    } else {
      apt::source { 'puppetlabs':
        ensure     => $source_ensure,
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main dependencies',
        key        => {
          'id'     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
          'server' => 'pgp.mit.edu'
        }
      }
      apt::source { 'puppetlabs_devel':
        ensure     => $devel_ensure,
        location   => 'http://apt.puppetlabs.com',
        repos      => 'devel',
        key        => {
          'id'     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
          'server' => 'pgp.mit.edu'
        }
      }
    }

  }#manage_repos

}
