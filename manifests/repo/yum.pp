# setup the puppetlabs yum repo

class puppet::repo::yum {
  include ::puppet

  if $::puppet::manage_repos {
    $lc_collection_name = downcase($puppet::collection)
    yumrepo { "puppetlabs-${lc_collection_name}":
      descr    => "Puppet Labs Collection ${::puppet::collection} EL ${::operatingsystemmajrelease} - ${::architecture}",
      baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/${::puppet::collection}/${::architecture}",
      enabled  => '1',
      gpgcheck => '1',
      gpgkey   => 'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
    }

  } # manage_repos
}
