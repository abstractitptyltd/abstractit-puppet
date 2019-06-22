# setup the puppetlabs apt repo

class puppet::repo::apt {
  include ::puppet
  if $::puppet::manage_repos {
    #we only do anything if we're managing repos.
    include ::apt
    if $::puppet::enable_repo {
      $repo_ensure = 'present'
    } else {
      $repo_ensure = 'absent'
    }

    $lc_collection_name = downcase($::puppet::collection)
    apt::source { "puppetlabs-${lc_collection_name}":
      ensure   => 'present',
      location => 'http://apt.puppetlabs.com',
      repos    => $::puppet::collection,
      key      => {
        'id'     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
        'server' => 'pgp.mit.edu',
      },
    }

  }#manage_repos

}
