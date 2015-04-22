# setup the puppetlabs yum repo

class puppet::repo::yum {
  include ::puppet

  if $::puppet::manage_repos {
    if $::puppet::enable_repo {
      $source_enable = '1'
    } else {
      $source_enable = '0'
    }

    if $::puppet::enable_devel_repo {
      $devel_enabled = '1'
    } else {
      $devel_enabled = '0'
    }
    if $::puppet::collection != undef {
      yumrepo { "puppetlabs-${::puppet::collection}":
        descr    => "Puppet Labs Collection ${::puppet::collection} EL ${::operatingsystemmajrelease} - ${::architecture}",
        baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/${::puppet::collection}/${::architecture}",
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
      }
    }

    yumrepo { 'puppetlabs-products':
      descr    => "Puppet Labs Products EL ${::operatingsystemmajrelease} - ${::architecture}",
      baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/products/${::architecture}",
      enabled  => '1',
      gpgcheck => '1',
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
    }

    yumrepo { 'puppetlabs-products-source':
      descr    => "Puppet Labs Products EL ${::operatingsystemmajrelease} - ${::architecture} - Source",
      baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/products/SRPMS",
      enabled  => $source_enable,
      gpgcheck => '1',
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
    }

    yumrepo { 'puppetlabs-deps':
      descr    => "Puppet Labs Dependencies EL ${::operatingsystemmajrelease} - ${::architecture}",
      baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/dependencies/${::architecture}",
      enabled  => '1',
      gpgcheck => '1',
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
    }

    yumrepo { 'puppetlabs-deps-source':
      descr          => "Puppet Labs Dependencies EL ${::operatingsystemmajrelease} - ${::architecture} - Source",
      baseurl        => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/dependencies/SRPMS",
      enabled        => $source_enable,
      gpgcheck       => '1',
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
      failovermethod => 'priority'
    }

    yumrepo { 'puppetlabs-devel':
      descr    => "Puppet Labs Devel EL ${::operatingsystemmajrelease} - ${::architecture}",
      baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/devel/${::architecture}",
      enabled  => $devel_enabled,
      gpgcheck => '1',
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
    }

    yumrepo { 'puppetlabs-devel-source':
      descr    => "Puppet Labs Devel EL ${::operatingsystemmajrelease} - ${::architecture} - Source",
      baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/devel/SRPMS",
      enabled  => $source_enable,
      gpgcheck => '1',
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
    }

  } # manage_repos
}
