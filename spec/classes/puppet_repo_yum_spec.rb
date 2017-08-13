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
        let(:pre_condition){"class{'::puppet':}"}
        it 'should add the puppetlabs-products yum repo' do
          case facts['operatingsystemmajrelease']
          when '5'
            should contain_yumrepo('puppetlabs-products').with({
              'descr'=>'Puppet Labs Products EL 5 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/5/products/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          when '6'
            should contain_yumrepo('puppetlabs-products').with({
              'descr'=>'Puppet Labs Products EL 6 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/6/products/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          when '7'
            should contain_yumrepo('puppetlabs-products').with({
              'descr'=>'Puppet Labs Products EL 7 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/7/products/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          end
        end
        it 'should add the puppetlabs-deps yum repo' do
          case facts['operatingsystemmajrelease']
          when '5'
            should contain_yumrepo('puppetlabs-deps').with({
              'descr'=>'Puppet Labs Dependencies EL 5 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/5/dependencies/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          when '6'
            should contain_yumrepo('puppetlabs-deps').with({
              'descr'=>'Puppet Labs Dependencies EL 6 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/6/dependencies/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          when '7'
            should contain_yumrepo('puppetlabs-deps').with({
              'descr'=>'Puppet Labs Dependencies EL 7 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/7/dependencies/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          end
        end
        it 'should disable the puppetlabs-devel yum repo' do
          case facts['operatingsystemmajrelease']
          when '5'
            should contain_yumrepo('puppetlabs-devel').with({
              'descr'=>'Puppet Labs Devel EL 5 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/5/devel/x86_64',
              'enabled'=>'0',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          when '6'
            should contain_yumrepo('puppetlabs-devel').with({
              'descr'=>'Puppet Labs Devel EL 6 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/6/devel/x86_64',
              'enabled'=>'0',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          when '7'
            should contain_yumrepo('puppetlabs-devel').with({
              'descr'=>'Puppet Labs Devel EL 7 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/7/devel/x86_64',
              'enabled'=>'0',
              'gpgcheck'=>'1',
              'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
            })
          end
        end
      end#no params
      context 'when ::puppet::manage_repos is false' do
        let(:pre_condition){"class{'::puppet': manage_repos => false}"}
        it 'should not lay down any yum repos' do
          should_not contain_yumrepo('puppetlabs-products')
          should_not contain_yumrepo('puppetlabs-deps')
          should_not contain_yumrepo('puppetlabs-devel')
        end
      end
      context 'when ::puppet::manage_repos is true' do

        context 'when ::puppet::collection is defined' do
          let(:pre_condition){"class{'::puppet': collection => 'BOGON'"}
          it 'should contain the puppetlabs ::puppet::collection repository' do
            case facts['operatingsystemmajrelease']
            when '5'
              should contain_yumrepo('puppetlabs-bogon').with({
                'descr'=>'Puppet Labs Collection BOGON EL 5 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/5/BOGON/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
              should_not contain_yumrepo('puppetlabs-products')
              should_not contain_yumrepo('puppetlabs-deps')
              should_not contain_yumrepo('puppetlabs-devel')
            when '6'
              should contain_yumrepo('puppetlabs-bogon').with({
                'descr'=>'Puppet Labs Collection BOGON EL 6 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/6/BOGON/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
              should_not contain_yumrepo('puppetlabs-products')
              should_not contain_yumrepo('puppetlabs-deps')
              should_not contain_yumrepo('puppetlabs-devel')
            when '7'
              should contain_yumrepo('puppetlabs-bogon').with({
                'descr'=>'Puppet Labs Collection BOGON EL 7 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/7/BOGON/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
              should_not contain_yumrepo('puppetlabs-products')
              should_not contain_yumrepo('puppetlabs-deps')
              should_not contain_yumrepo('puppetlabs-devel')
            end#end case
          end
        end #end puppet::collection

        context 'when ::puppet::enable_devel_repo is false' do
          let(:pre_condition){"class{'::puppet': enable_devel_repo => false}"}
          it 'should disable the puppetlabs-devel yum repo' do
            case facts['operatingsystemmajrelease']
            when '5'
              should contain_yumrepo('puppetlabs-devel').with({
                'descr'=>'Puppet Labs Devel EL 5 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/5/devel/x86_64',
                'enabled'=>'0',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
            when '6'
              should contain_yumrepo('puppetlabs-devel').with({
                'descr'=>'Puppet Labs Devel EL 6 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/6/devel/x86_64',
                'enabled'=>'0',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
            when '7'
              should contain_yumrepo('puppetlabs-devel').with({
                'descr'=>'Puppet Labs Devel EL 7 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/7/devel/x86_64',
                'enabled'=>'0',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
            end#end case
          end
        end#end enable_devel_repo false

        context 'when ::puppet::enable_devel_repo is true' do
          let(:pre_condition){"class{'::puppet': enable_devel_repo => true}"}
          it 'should enable the puppetlabs_devel yum repo' do
            case facts['operatingsystemmajrelease']
            when '5'
              should contain_yumrepo('puppetlabs-devel').with({
                'descr'=>'Puppet Labs Devel EL 5 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/5/devel/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
            when '6'
              should contain_yumrepo('puppetlabs-devel').with({
                'descr'=>'Puppet Labs Devel EL 6 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/6/devel/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
            when '7'
              should contain_yumrepo('puppetlabs-devel').with({
                'descr'=>'Puppet Labs Devel EL 7 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/7/devel/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'https://yum.puppetlabs.com/RPM-GPG-KEY-puppet',
              })
            end
          end
        end#end devel_repo

      end
    end
  end
end
