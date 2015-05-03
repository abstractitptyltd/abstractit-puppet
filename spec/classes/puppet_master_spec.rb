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

    ['env_owner','hiera_eyaml_version','java_ram','passenger_max_pool_size','passenger_max_requests','passenger_pool_idle_time','passenger_stat_throttle_rate','puppet_fqdn','server_type','puppet_version','r10k_version'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let(:params) {{strings => false }}
        it 'should fail' do
          skip 'This does not work as is'
          expect { subject }.to raise_error(Puppet::Error)#, /false is not a string./)
        end
      end
    end#strings

  end#input validation

  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
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
                should contain_class('puppet::master::server')#.that_comes_after('Class[puppet::master::hiera]')
              end
            end
            context 'when server_type is set to passenger' do
              it 'should properly instantiate the puppet::master::passenger class' do
                should contain_class('puppet::master::passenger')#.that_comes_after('Class[puppet::master::hiera]')
              end
            end
          end
        end
      end#no params

      context 'when the autosign parameter is true' do
        let(:params) {{'autosign' => true}}
        it 'should properly instantiate the puppet::master::config class' do
          should contain_class('puppet::master::config').that_comes_before('Class[puppet::master::hiera]')
        end
      end#autosign
      context 'when the basemodulepath parameter has a custom value' do
        let(:params) {{'basemodulepath' => '/BOGON'}}
        it 'should properly instantiate the puppet::master::config class' do
          should contain_class('puppet::master::config')
        end
      end#environmentpath
      context 'when the environmentpath parameter has a custom value' do
        let(:params) {{'environmentpath' => '/BOGON'}}
        it 'should properly instantiate the puppet::master::config class' do
          should contain_class('puppet::master::config')
        end
      end#environmentpath
      context 'when the future_parser parameter is set to true' do
        let(:params) {{'future_parser' => true}}
        it 'should properly instantiate the puppet::master::config class' do
          should contain_class('puppet::master::config')
        end
      end#future_parser

      context 'when the java_ram parameter is set' do
        let(:params) {{'java_ram' => '768m'}}
        it 'should properly instantiate the puppet::master::config class' do
          should contain_class('puppet::master::config')
        end
      end#java_ram

      context 'when the eyaml_keys parameter is set to true' do
        let(:params) {{'eyaml_keys' => true}}
        it 'should properly instantiate the puppet::master::hiera class' do
          should contain_class('puppet::master::hiera')
        end
      end#eyaml_keys

      context 'when the hiera_backends parameter has a custom value' do
        let(:params) {{'hiera_backends' => {'yaml' => { 'datadir' => 'BOGON',} } }}
        it 'should properly instantiate the puppet::master::hiera class' do
          should contain_class('puppet::master::hiera')
        end
      end#hiera_backends

      context 'when the hiera_hierarchy parameter has a custom value' do
        let(:params) {{'hiera_hierarchy' => ['foo', 'bar', 'baz']}}
        it 'should properly instantiate the puppet::master::hiera class' do
          should contain_class('puppet::master::hiera')
        end
      end#hiera_hierarchy

      # context 'when the hieradatata_path parameter has a custom value' do
      #   let(:params) {{'hieradata_path' => '/BOGON'}}
      #   it 'should properly instantiate the puppet::master::hiera class' do
      #     should contain_class('puppet::master::hiera')
      #   end
      # end#hieradatata_path

      context 'when the hiera_eyaml_version parameter has a custom value' do
        let(:params) {{'hiera_eyaml_version' => 'BOGON'}}
        it 'should properly instantiate the puppet::master::install class' do
          should contain_class('puppet::master::install')
        end
      end#hiera_eyaml_version

      context 'when the puppet_version parameter has a custom value' do
        let(:params) {{'puppet_version' => 'BOGON'}}
        it 'should properly instantiate the puppet::master::install class' do
          should contain_class('puppet::master::install')
        end
      end#puppet_version

      context 'when the server_version parameter has a custom value' do
        let(:params) {{'server_version' => 'BOGON'}}
        it 'should properly instantiate the puppet::master::install class' do
          should contain_class('puppet::master::install')
        end
      end#server_version

      # context 'when the passenger_max_pool_size parameter has a custom value' do
      #   let(:params) {{'passenger_max_pool_size' => 'BOGON'}}
      #   it 'should properly instantiate the puppet::master::passenger class' do
      #     should contain_class('puppet::master::passenger')
      #   end
      # end#passenger_max_pool_size

      # context 'when the passenger_max_requests parameter has a custom value' do
      #   let(:params) {{'passenger_max_requests' => 'BOGON'}}
      #   it 'should properly instantiate the puppet::master::passenger class' do
      #     should contain_class('puppet::master::passenger')
      #   end
      # end#passenger_max_requests

      # context 'when the passenger_pool_idle_time parameter has a custom value' do
      #   let(:params) {{'passenger_pool_idle_time' => 'BOGON'}}
      #   it 'should properly instantiate the puppet::master::passenger class' do
      #     should contain_class('puppet::master::passenger')
      #   end
      # end#passenger_pool_idle_time

      # context 'when the passenger_stat_throttle_rate parameter has a custom value' do
      #   let(:params) {{'passenger_stat_throttle_rate' => 'BOGON'}}
      #   it 'should properly instantiate the puppet::master::passenger class' do
      #     should contain_class('puppet::master::passenger')
      #   end
      # end#passenger_stat_throttle_rate

      # context 'when the puppet_fqdn parameter has a custom value' do
      #   let(:params) {{'puppet_fqdn' => 'BOGON'}}
      #   it 'should properly instantiate the puppet::master::passenger class' do
      #     should contain_class('puppet::master::passenger')
      #   end
      # end#puppet_fqdn

    end
  end
end
