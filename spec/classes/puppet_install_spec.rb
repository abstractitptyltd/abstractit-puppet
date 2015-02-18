#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::install', :type => :class do
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

#    ['bool'].each do |bools|
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

#    ['facter_version','hiera_version','puppet_version'].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let(:params) {{strings => false }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
#        end
#      end
#    end#strings

  end#input validation

  on_supported_os({
    :hardwaremodels => ['x86_64'],
    :supported_os   => [
      {
        "operatingsystem" => "Ubuntu",
        "operatingsystemrelease" => [
          "12.04",
          "14.04"
        ]
      },
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
    context "When on an #{os} system" do
      let(:facts) do
        facts
      end

      it "should install the puppetlabs-release package" do
        should contain_package('puppetlabs-release').with({'ensure' => 'latest'})
      end#puppetlabs-release

      case facts[:osfamily]
      when 'Debian'
        ['puppet','puppet-common'].each do |pkg|
          context 'when fed no parameters' do
            it "should install the #{pkg} package"do
              should contain_package(pkg).with({
                'ensure' => 'installed'
              }).that_requires(
                'Package[puppetlabs-release]'
              ).that_requires(
                'Package[hiera]'
              ).that_requires(
                'Package[facter]'
              )
            end#specific package
          end#no params
        end#package iterator
      when 'RedHat'
        ['puppet'].each do |pkg|
          context 'when fed no parameters' do
            it "should install the #{pkg} package"do
              should contain_package(pkg).with({
                'ensure' => 'installed'
              }).that_requires(
                'Package[puppetlabs-release]'
              ).that_requires(
                'Package[hiera]'
              ).that_requires(
                'Package[facter]'
              )
            end#specific package
          end#no params
        end#package iterator
      end

      context 'when the $puppet::hiera_version param has a custom value' do
        let(:pre_condition) {"class{'::puppet': hiera_version => 'some_version'}"}
        it 'should install the specified version if the hiera packages' do
          should contain_package('hiera').with({'ensure' => 'some_version'})
        end
      end#facter_version
      context 'when the $puppet::facter_version param has a custom value' do
        let(:pre_condition) {"class{'::puppet': facter_version => 'some_version'}"}
        it 'should install the specified version if the facter packages' do
          should contain_package('facter').with({'ensure' => 'some_version'})
        end
      end#facter_version

      context 'when the $puppet::puppet_version param has a custom value' do
        let(:pre_condition) {"class{'::puppet': puppet_version => 'some_version'}"}
        case facts[:osfamily]
        when 'Debian'
          it 'should install the specified version if the puppet-common and puppet packages' do
            should contain_package('puppet').with({'ensure' => 'some_version'})
            should contain_package('puppet-common').with({
              'ensure' => 'some_version'
            }).that_requires(
              'Package[puppetlabs-release]'
            ).that_requires(
              'Package[hiera]'
            ).that_requires(
              'Package[facter]'
            )
          end
        when 'RedHat'
          it 'should install the specified version if the puppet package' do
            should contain_package('puppet').with({
              'ensure' => 'some_version'
            }).that_requires(
              'Package[puppetlabs-release]'
            ).that_requires(
              'Package[hiera]'
            ).that_requires(
              'Package[facter]'
            )
          end
        end
      end#puppet_version
    end
  end
end
