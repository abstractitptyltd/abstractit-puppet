#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::config', :type => :class do
  let(:facts) { DEFAULT_FACTS_BY_SYMBOL }

  context 'input validation' do
    ['environmentpath'].each do |paths|
      context "when the #{paths} parameter is not an absolute path" do
        let (:params) {{ paths => 'foo' }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
        end
      end
    end
    ['future_parser'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let (:params) {{bools => "BOGON"}}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end
  end

  context 'default params' do
    it do
      should compile.with_all_deps
      should contain_ini_setting('Puppet environmentpath').with(
        :path=>'/etc/puppet/puppet.conf',
        :value=>'/etc/puppet/environments')
      should contain_ini_setting('Puppet basemodulepath').with(
        :path=>'/etc/puppet/puppet.conf',
        :value=>nil)
      should contain_ini_setting('certname').with(
        :path=>'/etc/puppet/puppet.conf',
        :value=>'unittest.cloud.unittest.com')
      should contain_ini_setting('autosign').with(
        :path=>'/etc/puppet/puppet.conf',
        :value=>false)
      should contain_ini_setting('master parser').with(
        :path=>'/etc/puppet/puppet.conf',
        :value=>'future')
      should_not contain_ini_setting('dns_alt_names')
    end
  end

  context 'environmentpath => /BOGON' do
    let (:params){{'environmentpath' => '/BOGON'}}
    it do
      should compile.with_all_deps
      should contain_ini_setting('Puppet environmentpath').with(
        :path=>'/etc/puppet/puppet.conf',
        :setting=>'environmentpath',
        :value=>'/BOGON')
    end
  end

  context 'extra_module_path => /BOGON:/BOGON2' do
    let (:params){{'extra_module_path' => '/BOGON:/BOGON2'}}
    it do
      should compile.with_all_deps
      should contain_ini_setting('Puppet basemodulepath').with(
        :path=>'/etc/puppet/puppet.conf',
        :value=>'/BOGON:/BOGON2')
    end
  end

  context 'future_parser => true' do
    let (:params) {{'future_parser' => true}}
    it do
      should compile.with_all_deps
      should contain_ini_setting('master parser').with(
        :path  =>'/etc/puppet/puppet.conf',
        :value =>'future')
    end
  end

  context 'puppet_fqdn => puppet.unittest.com' do
    let (:params) {{'puppet_fqdn' => 'puppet.unittest.com'}}
    it do
      should compile.with_all_deps
      should contain_ini_setting('certname').with(
        :path  =>'/etc/puppet/puppet.conf',
        :value =>'puppet.unittest.com')
    end
  end

  context 'autosign => []' do
    let(:params) {{ 'autosign' => [] }}
    it do
      expect { subject }.to raise_error(Puppet::Error, /to be either/)
    end
  end

  context 'autosign => {}' do
    let(:params) {{ 'autosign' => {} }}
    it do
      expect { subject }.to raise_error(Puppet::Error, /to be either/)
    end
  end


  context 'autosign => true' do
    let (:params) {{'autosign' => true}}
    it 'should not enable autosign' do
      should compile.with_all_deps
      should contain_ini_setting('autosign').with(
        :path=>'/etc/puppet/puppet.conf',
        :setting=>'autosign',
        :value=>true)
    end
  end

  context 'autosign => /foo/bar.sh' do
    let (:params) {{'autosign' => '/foo/bar.sh'}}
    it 'should enable autosign' do
      should compile.with_all_deps
      should contain_ini_setting('autosign').with(
        :path=>'/etc/puppet/puppet.conf',
        :setting=>'autosign',
        :value=>'/foo/bar.sh')
    end
  end

  context 'dns_alt_names => foo:bar' do
    let (:params) {{'dns_alt_names' => 'foo:bar'}}
    it do
      should compile.with_all_deps
      should contain_ini_setting('dns_alt_names').with(
        :path=>'/etc/puppet/puppet.conf',
        :setting=>'dns_alt_names',
        :value=>'foo:bar')
    end
  end

end
