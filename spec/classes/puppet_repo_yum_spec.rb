#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::repo::yum', :type => :class do

  on_supported_os({
    :hardwaremodels => ['x86_64'],
    :supported_os   => [
      {
        "operatingsystem" => "RedHat",
        "operatingsystemrelease" => [
          "5",
          "6",
          "7"
        ]
      },
      {
        "operatingsystem" => "CentOS",
        "operatingsystemrelease" => [
          "5",
          "6",
          "7"
        ]
      }
    ],
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
      it { is_expected.to compile.with_all_deps }
      context 'when ::puppet has default parameters' do
        let(:pre_condition){"class{'::puppet': collection => 'PC1'}"}
        it 'should contain the puppetlabs ::puppet::collection repository' do
          case facts['operatingsystemmajrelease']
          when '5'
            should contain_yumrepo('puppetlabs-pc1').with({
              'descr'=>'Puppet Labs Collection PC1 EL 5 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/5/BOGON/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          when '6'
            should contain_yumrepo('puppetlabs-pc1').with({
              'descr'=>'Puppet Labs Collection PC1 EL 6 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/6/BOGON/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          when '7'
            should contain_yumrepo('puppetlabs-pc1').with({
              'descr'=>'Puppet Labs Collection PC1 EL 7 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/7/BOGON/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          end#end case
        end
      end#no params

      context 'when ::puppet::manage_repos is false' do
        let(:pre_condition){"class{'::puppet': manage_repos => false,  collection => 'PC1'}"}
        it 'should not lay down any yum repos' do
          should_not contain_yumrepo('puppetlabs-pc1')
        end
      end

    end
  end
end
