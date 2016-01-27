#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::install', :type => :class do
  let(:pre_condition){ 'class{"puppet":}' }
  let(:pre_condition){ 'class{"puppet::defaults":}' }
  let(:pre_condition){ 'class{"puppet::master":}' }
  on_supported_os({
      :hardwaremodels => ['x86_64'],
      :supported_os   => [
        {
          "operatingsystem" => "Ubuntu",
          "operatingsystemrelease" => [
            "14.04"
          ]
        },
        {
          "operatingsystem" => "CentOS",
          "operatingsystemrelease" => [
            "7"
          ]
        }
      ],
    }).each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
      it { is_expected.to compile.with_all_deps }

      it 'should contain the ::puppet::master::install::deps class' do
        should contain_class('puppet::master::install::deps')
      end

      context 'when fed no parameters' do
        context 'when ::puppet::allinone is true' do
          let(:pre_condition){"class{'::puppet': allinone => true}"}
          it "should install the puppetserver package" do
            should contain_package('puppetserver').with({
              :ensure=>"installed",
            }).that_requires(
              'Class[puppet::master::install::deps]'
            ).that_requires(
              'Class[puppet::install]'
            )
          end
        end# allinone true
        context 'when ::puppet::allinone is false' do
          let(:pre_condition){"class{'::puppet': allinone => false}"}
          let(:pre_condition){"class{'::puppet::master': server_type=>'passenger' }"}
          case facts[:osfamily]
          when 'Debian'
            it 'should install the puppetmaster package' do
              should contain_package('puppetmaster').with({
                :ensure=>"installed",
              }).that_requires('Class[puppet::master::install::deps]')
            end
          when 'RedHat'
            it 'should install the puppet-server package' do
              should contain_package('puppet-server').with({
                :ensure=>"installed",
              }).that_requires(
                'Class[puppet::master::install::deps]'
              ).that_requires(
                'Class[puppet::install]'
              )
            end
          end
        end# allinone false

        context 'when ::puppet::master::manage_hiera_eyaml_package is true' do
          let(:pre_condition){"class{'::puppet::master': manage_hiera_eyaml_package=>true }"}
          if Puppet.version.to_f >= 4.0
            context 'when puppetversion >= 4' do
              it 'should install the hiera-eyaml package with the puppetserver_gem provider' do
                should contain_package('hiera-eyaml').with({
                  :ensure   => 'installed',
                  :provider => 'puppetserver_gem'
                })
              end
            end
          else
            context 'when puppetversion < 4' do
              it 'should install the hiera-eyaml package with the gem provider' do
                should contain_package('hiera-eyaml').with({
                  :ensure   => 'installed',
                  :provider => 'gem'
                })
              end
            end
          end
        end#manage_hiera_eyaml_package true

        context 'when ::puppet::master::manage_hiera_eyaml_package is false' do
          let(:pre_condition){"class{'::puppet::master': manage_hiera_eyaml_package=>false }"}
          it 'should not install the hiera-eyaml package' do
            should_not contain_package('hiera-eyaml')
          end
        end#manage_hiera_eyaml_package false

        context 'when ::puppet::master::manage_deep_merge_package is true' do
          let(:pre_condition){"class{'::puppet::master': manage_deep_merge_package=>true }"}
          if Puppet.version.to_f >= 4.0
            context 'when puppetversion >= 4' do
              it 'should install the deep_merge package with the puppetserver_gem provider' do
                should contain_package('deep_merge').with({
                  :ensure   => 'installed',
                  :provider => 'puppetserver_gem'
                })
              end
            end
          else
            context 'when puppetversion < 4' do
              it 'should install the deep_merge package with the gem provider' do
                should contain_package('deep_merge').with({
                  :ensure   => 'installed',
                  :provider => 'gem'
                })
              end
            end
          end
        end#manage_deep_merge_package true

        context 'when ::puppet::master::manage_deep_merge_package is false' do
          let(:pre_condition){"class{'::puppet::master': manage_deep_merge_package=>false }"}
          it 'should not install the deep_merge package' do
            should_not contain_package('deep_merge')
          end
        end#manage_deep_merge_package false
      end#no params

      context 'when the a specific version of puppetserver is required' do
        context 'when ::puppet::allinone is true' do
          let(:pre_condition){"class{'::puppet': allinone => true}"}
          let(:pre_condition){"class{'::puppet::master': server_version => 'latest', server_type => 'puppetserver' }"}
          it "should install the specified version of the puppetserver package" do
            should contain_package('puppetserver').with({
              'ensure' => 'latest',
            }).that_requires(
              'Class[puppet::master::install::deps]'
            ).that_requires(
              'Class[puppet::install]'
            )
          end
        end# allinone true
        context 'when ::puppet::allinone is false' do
          if Puppet.version.to_f < 4.0
            # this fails in puppet 4
            let(:pre_condition){"class{'::puppet': allinone => false}"}
            let(:pre_condition){"class{'::puppet::master': puppet_version => '3.8.4', server_type => 'passenger' }"}
            case facts[:osfamily]
            when 'Debian'
              it 'should install the puppetmaster package' do
                should contain_package('puppetmaster').with({
                  'ensure' => '3.8.4',
                }).that_requires(
                  'Class[puppet::master::install::deps]'
                ).that_requires(
                  'Class[puppet::install]'
                )
              end
            when 'RedHat'
              it 'should install the puppet-server package' do
                should contain_package('puppet-server').with({
                  'ensure' => '3.8.4',
                }).that_requires(
                  'Class[puppet::master::install::deps]'
                ).that_requires(
                  'Class[puppet::install]'
                )
              end
            end
          end
        end# allinone false
        context 'when ::puppet::allinone is false and server_type is puppetserver' do
          let(:pre_condition){"class{'::puppet': allinone => false}"}
          let(:pre_condition){"class{'::puppet::master': server_type => 'puppetserver' }"}
          it 'should install the puppetserver package' do
            should contain_package('puppetserver').that_requires(
              'Class[puppet::master::install::deps]'
            ).that_requires(
              'Class[puppet::install]'
            )
          end
        end# allinone false server_type = puppetserver
        context 'when ::puppet::allinone is false server_version is set and server_type is puppetserver' do
          if Puppet.version.to_f < 4.0
            # this fails in puppet 4
            let(:pre_condition){"class{'::puppet': allinone => false}"}
            let(:pre_condition){"class{'::puppet::master': server_type => 'puppetserver', server_version => '2.1.2' }"}
            it 'should install the specified version of the puppetserver package' do
              should contain_package('puppetserver').with({
                'ensure' => '2.1.2',
              }).that_requires(
                'Class[puppet::master::install::deps]'
              ).that_requires(
                'Class[puppet::install]'
              )
            end
          end
        end# allinone false server_type = puppetserver
      end # specific version of puppetserver

      context 'when the hiera_eyaml_version param has a non-standard value' do
        let(:pre_condition) {"class{'::puppet::master': manage_hiera_eyaml_package=>true, hiera_eyaml_version=>'BOGON' }"}
        if Puppet.version.to_f >= 4.0
          context 'when puppetversion >= 4' do
            it 'should install the specified version of the hiera-eyaml package with the puppetserver_gem provider' do
              should contain_package('hiera-eyaml').with({
                :ensure   => 'BOGON',
                :provider => 'puppetserver_gem'
              })
            end
          end
        else
          context 'when puppetversion < 4' do
            it 'should install the specified version of the hiera-eyaml package with the gem provider' do
              should contain_package('hiera-eyaml').with({
                :ensure   => 'BOGON',
                :provider => 'gem'
              })
            end
          end
        end
      end # hiera_eyaml_version defined

      context 'when the deep_merge_version param has a non-standard value' do
        let(:pre_condition) {"class{'::puppet::master': manage_deep_merge_package=>true, deep_merge_version=>'BOGON' }"}
        if Puppet.version.to_f >= 4.0
          context 'when puppetversion >= 4' do
            it 'should install the specified version of the deep_merge package with the puppetserver_gem provider' do
              should contain_package('deep_merge').with({
                :ensure   => 'BOGON',
                :provider => 'puppetserver_gem'
              })
            end
          end
        else
          context 'when puppetversion < 4' do
            it 'should install the specified version of the deep_merge package with the gem provider' do
              should contain_package('deep_merge').with({
                :ensure   => 'BOGON',
                :provider => 'gem'
              })
            end
          end
        end
      end # deep_merge_version defined

    end
  end
end
