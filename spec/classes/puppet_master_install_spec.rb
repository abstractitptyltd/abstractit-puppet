#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::install', :type => :class do
  let(:pre_condition){ 'class{"puppet":}' }
  let(:pre_condition){ 'class{"puppet::defaults":}' }
  let(:pre_condition){ 'class{"puppet::master":}' }
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end

      it 'should contain the ::puppet::master::install::deps class' do
        should contain_class('puppet::master::install::deps')
      end

      # let(:pre_condition){"package{'puppet': ensure => 'present'}"}
      context 'when fed no parameters' do
        context 'when ::puppet::allinone is true' do
          let(:pre_condition){"class{'::puppet': allinone => true}"}
          it "should install the puppetserver package" do
            should contain_package('puppetserver').with({
              :ensure=>"installed",
            }).that_requires('Class[puppet::master::install::deps]')
          end
        end# allinone true
        context 'when ::puppet::allinone is false' do
          let(:pre_condition){"class{'::puppet': allinone => false}"}
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
              }).that_requires('Class[puppet::master::install::deps]')
            end
          end
        end# allinone false

        it 'should install the hiera-eyaml package' do
          should contain_package('hiera-eyaml').with({
            :ensure => 'installed',
            :provider => 'gem'
          })
        end
      end#no params

      context 'when the a specific version of puppetserver is required' do
        context 'when ::puppet::allinone is true' do
          let(:pre_condition){"class{'::puppet': allinone => true}"}
          let(:pre_condition){"class{'::puppet::master': server_version=>'BOGON' }"}
          it "should install the puppetserver package" do
            skip 'This does not work as is'
            should contain_package('puppetserver').with({
              :ensure=>'BOGON',
              }).that_requires(
                'Class[puppet::master::install::deps]'
              ).that_requires(
                'Class[puppet::install]'
              )
          end
        end# allinone true
        context 'when ::puppet::allinone is false' do
          let(:pre_condition){"class{'::puppet': allinone => false}"}
          let(:pre_condition){"class{'::puppet::master': puppet_version=>'BOGON' }"}
          case facts[:osfamily]
          when 'Debian'
            it 'should install the puppetmaster package' do
              should contain_package('puppetmaster').with({
                :ensure=>'BOGON',
              }).that_requires(
                'Class[puppet::master::install::deps]'
              ).that_requires(
                'Class[puppet::install]'
              )
            end
          when 'RedHat'
            it 'should install the puppet-server package' do
              should contain_package('puppet-server').with({
                :ensure=>'BOGON',
              }).that_requires('Class[puppet::master::install::deps]')
            end
          end
        end# allinone false
      end # specific version of puppetserver

      context 'when the hiera_eyaml_version param has a non-standard value' do
        let(:pre_condition) {"class{'::puppet::master': hiera_eyaml_version=>'BOGON' }"}
        it 'should install the specified version of the hiera-eyaml package' do
          should contain_package('hiera-eyaml').with({
            'ensure' => "BOGON",
            'provider'=> "gem"
          })
        end
      end # hiera_eyaml_version defined

    end
  end
end
