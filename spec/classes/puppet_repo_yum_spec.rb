#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::repo::yum', :type => :class do
  context 'input validation' do

#    ['path'].each do |paths|
#      context "when the #{paths} parameter is not an absolute path" do
#        let(:params) {{ paths => 'foo' }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
#        end
#      end
#    end#absolute path

#    ['array'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let(:params) {{ arrays => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not an Array./)
#        end
#      end
#    end#arrays

#    ['bools'].each do |bools|
#      context "when the #{bools} parameter is not an boolean" do
#        let(:params) {{bools => "BOGON"}}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
#        end
#      end
#    end#bools

#    ['hash'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let(:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes

#    ['opt_hash'].each do |opt_hashes|
#      context "when the optional param #{opt_hashes} parameter has a value, but not a hash" do
#        let(:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#opt_hashes


#    ['string'].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let(:params) {{strings => false }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
#        end
#      end
#    end#strings

#    ['opt_strings'].each do |optional_strings|
#      context "when the optional parameter #{optional_strings} has a value, but it is not a string" do
#        let(:params) {{optional_strings => true }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /true is not a string./)
#        end
#      end
#    end#opt_strings

  end#input validation
  
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
        facts
      end
      context 'when ::puppet has default parameters' do
        let(:pre_condition){"class{'::puppet':}"}
        it 'should add the puppetlabs-products yum repo' do
          pending 'Working on it'
          case facts['operatingsystemmajrelease']
          when '5'
            should contain_yumrepo('puppetlabs-products').with({
              'name'=>'Puppet Labs Dependencies EL 5 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/5/products/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          when '6'
            should contain_yumrepo('puppetlabs-products').with({
              'name'=>'Puppet Labs Dependencies EL 6 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/6/products/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          when '7'
            should contain_yumrepo('puppetlabs-products').with({
              'name'=>'Puppet Labs Dependencies EL 7 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/7/products/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          end
        end
        it 'should add the puppetlabs-deps yum repo' do
          pending 'Working on it'
          case facts['operatingsystemmajrelease']
          when '5'
            should contain_yumrepo('puppetlabs-deps').with({
              'name'=>'Puppet Labs Dependencies EL 5 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/5/dependencies/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          when '6'
            should contain_yumrepo('puppetlabs-deps').with({
              'name'=>'Puppet Labs Dependencies EL 6 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/6/dependencies/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          when '7'
            should contain_yumrepo('puppetlabs-deps').with({
              'name'=>'Puppet Labs Dependencies EL 7 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/7/dependencies/x86_64',
              'enabled'=>'1',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          end
        end
        it 'should disable the puppetlabs-devel yum repo' do
          pending 'Working on it'
          case facts['operatingsystemmajrelease']
          when '5'
            should contain_yumrepo('puppetlabs-devel').with({
              'name'=>'Puppet Labs Dependencies EL 5 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/5/devel/x86_64',
              'enabled'=>'0',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          when '6'
            should contain_yumrepo('puppetlabs-devel').with({
              'name'=>'Puppet Labs Dependencies EL 6 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/6/devel/x86_64',
              'enabled'=>'0',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          when '7'
            should contain_yumrepo('puppetlabs-devel').with({
              'name'=>'Puppet Labs Dependencies EL 7 - x86_64',
              'baseurl'=>'http://yum.puppetlabs.com/el/7/devel/x86_64',
              'enabled'=>'0',
              'gpgcheck'=>'1',
              'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
            })
          end
        end
      end#no params
      context 'when ::puppet::manage_repos is false' do
        let(:pre_condition){"class{'::puppet': manage_repos => false}"}
        it 'should not lay down any yum repos' do
          pending 'Working on it'
          should_not contain_yumrepo('puppetlabs-products')
          should_not contain_yumrepo('puppetlabs-deps')
          should_not contain_yumrepo('puppetlabs-devel')
        end
      end
      context 'when ::puppet::manage_repos is true' do
        context 'when ::puppet::devel_repo is false' do
          let(:pre_condition){"class{'::puppet': devel_repo => false}"}
          it 'should disable the puppetlabs-devel yum repo' do
            pending 'Working on it'
            case facts['operatingsystemmajrelease']
            when '5'
              should contain_yumrepo('puppetlabs-devel').with({
                'name'=>'Puppet Labs Dependencies EL 5 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/5/devel/x86_64',
                'enabled'=>'0',
                'gpgcheck'=>'1',
                'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
              })
            when '6'
              should contain_yumrepo('puppetlabs-devel').with({
                'name'=>'Puppet Labs Dependencies EL 6 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/6/devel/x86_64',
                'enabled'=>'0',
                'gpgcheck'=>'1',
                'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
              })
            when '7'
              should contain_yumrepo('puppetlabs-devel').with({
                'name'=>'Puppet Labs Dependencies EL 7 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/7/devel/x86_64',
                'enabled'=>'0',
                'gpgcheck'=>'1',
                'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
              })
            end
          end
          context 'and ::puppet::enable_devel_repo is true' do
            let(:pre_condition){"class{'::puppet': devel_repo => false, enable_devel_repo => true }"}
            it 'should enable the puppetlabs_devel yum repo' do
              pending 'Working on it'
              case facts['operatingsystemmajrelease']
              when '5'
                should contain_yumrepo('puppetlabs-devel').with({
                  'name'=>'Puppet Labs Dependencies EL 5 - x86_64',
                  'baseurl'=>'http://yum.puppetlabs.com/el/5/devel/x86_64',
                  'enabled'=>'1',
                  'gpgcheck'=>'1',
                  'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
                })
              when '6'
                should contain_yumrepo('puppetlabs-devel').with({
                  'name'=>'Puppet Labs Dependencies EL 6 - x86_64',
                  'baseurl'=>'http://yum.puppetlabs.com/el/6/devel/x86_64',
                  'enabled'=>'1',
                  'gpgcheck'=>'1',
                  'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
                })
              when '7'
                should contain_yumrepo('puppetlabs-devel').with({
                  'name'=>'Puppet Labs Dependencies EL 7 - x86_64',
                  'baseurl'=>'http://yum.puppetlabs.com/el/7/devel/x86_64',
                  'enabled'=>'1',
                  'gpgcheck'=>'1',
                  'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
                })
              end
            end
          end
        end
        context 'when ::puppet::devel_repo is true' do
          let(:pre_condition){"class{'::puppet': devel_repo => true}"}
          it 'should enable the puppetlabs_devel yum repo' do
            pending 'Working on it'
            case facts['operatingsystemmajrelease']
            when '5'
              should contain_yumrepo('puppetlabs-devel').with({
                'name'=>'Puppet Labs Dependencies EL 5 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/5/devel/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
              })
            when '6'
              should contain_yumrepo('puppetlabs-devel').with({
                'name'=>'Puppet Labs Dependencies EL 6 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/6/devel/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
              })
            when '7'
              should contain_yumrepo('puppetlabs-devel').with({
                'name'=>'Puppet Labs Dependencies EL 7 - x86_64',
                'baseurl'=>'http://yum.puppetlabs.com/el/7/devel/x86_64',
                'enabled'=>'1',
                'gpgcheck'=>'1',
                'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
              })
            end
          end
          context 'and ::puppet::enable_devel_repo is false' do
            let(:pre_condition){"class{'::puppet': devel_repo => true, enable_devel_repo => false}"}
             it 'should behave the same' do
               pending 'Working on it'
               case facts['operatingsystemmajrelease']
               when '5'
                 should contain_yumrepo('puppetlabs-devel').with({
                   'name'=>'Puppet Labs Dependencies EL 5 - x86_64',
                   'baseurl'=>'http://yum.puppetlabs.com/el/5/devel/x86_64',
                   'enabled'=>'1',
                   'gpgcheck'=>'1',
                   'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
                 })
               when '6'
                 should contain_yumrepo('puppetlabs-devel').with({
                   'name'=>'Puppet Labs Dependencies EL 6 - x86_64',
                   'baseurl'=>'http://yum.puppetlabs.com/el/6/devel/x86_64',
                   'enabled'=>'1',
                   'gpgcheck'=>'1',
                   'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
                 })
               when '7'
                 should contain_yumrepo('puppetlabs-devel').with({
                   'name'=>'Puppet Labs Dependencies EL 7 - x86_64',
                   'baseurl'=>'http://yum.puppetlabs.com/el/7/devel/x86_64',
                   'enabled'=>'1',
                   'gpgcheck'=>'1',
                   'gpgkey'=>'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs',
                 })
               end
            end
          end
        end#end devel_repo

      end
    end
  end
end
