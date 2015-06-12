#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master', :type => :class do
  context 'input validation' do

    ['basemodulepath','environmentpath', 'hieradata_path'].each do |paths|
      context "when the #{paths} parameter is not an absolute path" do
        let(:params) {{ paths => 'foo' }}
        it 'should fail' do
          skip 'This does not work as is'
          expect { subject }.to raise_error(Puppet::Error)#, /"foo" is not an absolute path/)
        end
      end
    end#absolute path

    ['hiera_hierarchy'].each do |arrays|
      context "when the #{arrays} parameter is not an array" do
        let(:params) {{ arrays => 'this is a string'}}
        it 'should fail' do
          skip 'This does not work as is'
           expect { subject }.to raise_error(Puppet::Error)#, /is not an Array./)
        end
      end
    end#arrays

    ['autosign','eyaml_keys','future_parser'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let(:params) {{bools => "BOGON"}}
        it 'should fail' do
          skip 'This does not work as is'
          expect { subject }.to raise_error(Puppet::Error)#, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end#bools

    ['hiera_backends'].each do |hashes|
      context "when the #{hashes} parameter is not an hash" do
        let(:params) {{ hashes => 'this is a string'}}
        it 'should fail' do
          skip 'This does not work as is'
           expect { subject }.to raise_error(Puppet::Error)#, /is not a Hash./)
        end
      end
    end#hashes

    ['env_owner','environment_timeout','hiera_eyaml_version','hiera_eyaml_pkcs7_private_key','hiera_eyaml_pkcs7_private_key_file','hiera_eyaml_pkcs7_public_key','hiera_eyaml_pkcs7_public_key_file','java_ram','passenger_max_pool_size','passenger_max_requests','passenger_pool_idle_time','passenger_stat_throttle_rate','puppet_fqdn','server_type','puppet_version','r10k_version'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let(:params) {{strings => false }}
        it 'should fail' do
          skip 'This does not work as is'
          expect { subject }.to raise_error(Puppet::Error)#, /false is not a string./)
        end
      end
    end#strings

  end#input validation

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
      context 'when fed no parameters' do
        it 'should properly instantiate the puppet::master::install class' do
          should contain_class('puppet::master::install').that_comes_before('Class[puppet::master::config]')
        end
        it 'should properly instantiate the puppet::master::config class' do
          should contain_class('puppet::master::config').that_comes_before('Class[puppet::master::hiera]')
        end
        it 'should properly instantiate the puppet::master::hiera class' do
          should contain_class('puppet::master::hiera')
        end

        if Puppet.version.to_f >= 4.0
          context 'when puppetversion >= 4' do
            it 'should properly instantiate the puppet::master::server class' do
              should contain_class('puppet::master::server')
            end
          end
        else
          context 'when puppetversion < 4' do
            context 'when server_type is set to puppetserver' do
              let(:params) {{'server_type' => 'puppetserver'}}
              it 'should properly instantiate the puppet::master::server class' do
                should contain_class('puppet::master::server')
              end
            end
            context 'when server_type is set to passenger' do
              it 'should properly instantiate the puppet::master::passenger class' do
                should contain_class('puppet::master::passenger')
              end
            end
          end
        end
      end#no params

    end
  end
end
