#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::install', :type => :class do
  context 'input validation' do

    ['facter_version','hiera_version','puppet_version'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => false }}
        it do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings

  end#input validation
  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      let (:facts) {{ 'osfamily' => osfam }}

      context 'default params' do
        it do
          should contain_package('puppetlabs-release').with(:ensure => 'latest')
          should contain_package('hiera').with(:ensure => 'installed')
          should contain_package('facter').with(:ensure => 'installed')
          should contain_package('puppet').with(:ensure => 'installed')
          should contain_package('puppet-common').with(:ensure => 'installed')
        end
      end#no params

      context 'hiera_version => 1.0' do
        let(:params) {{ :hiera_version => '1.0' }}
        it do
          should contain_package('hiera').with(:ensure => '1.0')
        end
      end#hiera_version

      context 'facter_version => 1.0' do
        let(:params) {{ :facter_version => '1.0' }}
        it do
          should contain_package('facter').with(:ensure => '1.0')
        end
      end#facter_version

      context 'puppet_version => 1.0' do
        let(:params) {{ :puppet_version => '1.0' }}
        it do
          should contain_package('puppet').with(:ensure => '1.0')
          should contain_package('puppet-common').with(:ensure => '1.0')
        end
      end#puppet_version

    end
  end
end
