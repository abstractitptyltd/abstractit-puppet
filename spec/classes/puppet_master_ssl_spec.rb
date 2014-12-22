#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::ssl', :type => :class do
  let(:facts) { DEFAULT_FACTS_BY_SYMBOL }

  context 'default params' do
    it do
      expect { subject }.to raise_error(Puppet::Error)
    end
  end

  context 'puppet_ca_cert => cert, puppet_ca_key => key, puppet_fqdn => puppet.test.com' do
    let(:params) { {
      :puppet_ca_cert => 'cert',
      :puppet_ca_key  => 'key',
      :puppet_fqdn    => 'puppet.test.com'
    }}
    it do
      should compile.with_all_deps
      should contain_file('/var/lib/puppet/ssl')
      should contain_file('/var/lib/puppet/ssl/ca')
      should contain_file('/var/lib/puppet/ssl/ca/private')
      should contain_file('/var/lib/puppet/ssl/ca/ca_crt.pem').with(
        'content' => 'cert')
      should contain_file('/var/lib/puppet/ssl/ca/ca_key.pem').with(
        'content' => 'key')
      should contain_file('/var/lib/puppet/ssl/ca/private/ca.pass').with(
        'ensure'  => 'absent')
      should contain_exec('create_initial_serial')
      should contain_exec('generate_puppet_ssl_cert').with(
        'command' => /puppet cert -g puppet.test.com/,
        'creates' => '/var/lib/puppet/ssl/certs/puppet.test.com.pem')
    end
  end

  context 'puppet_ca_cert => cert, puppet_ca_key => key, puppet_fqdn => puppet.test.com, puppet_ca_pass => 12345' do
    let(:params) { {
      :puppet_ca_cert => 'cert',
      :puppet_ca_key  => 'key',
      :puppet_fqdn    => 'puppet.test.com',
      :puppet_ca_pass => '12345',
    }}
    it do
      should compile.with_all_deps
      should contain_file('/var/lib/puppet/ssl/ca/private/ca.pass').with(
        'ensure'  => 'file',
        'content' => '12345')
    end
  end

end
