#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master', :type => :class do
  context 'input validation' do
    ['manage_ssl'].each do |bool|
      context "when the #{bool} parameter is not an bool" do
        let (:params) {{ bool => 'this is a string'}}
        it 'should fail' do
           expect { subject }.to raise_error(Puppet::Error, /is not a bool/)
        end
      end
    end

    ['module_path', 'pre_module_path'].each do |string|
      context "when the #{string} parameter is not a string" do
        let (:params) {{string => false }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end
  end

  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      my_facts = DEFAULT_FACTS_BY_SYMBOL.clone
      my_facts['osfamily'] = osfam
      let (:facts) { my_facts }

      context 'default params' do
        it do
          should compile.with_all_deps

          should contain_class('puppet::master::install').with(
            :puppet_version      => "installed",
            :r10k_version        => "installed",
            :hiera_eyaml_version => "installed"
          ).that_comes_before('Class[puppet::master::config]')

          should contain_class('puppet::master::config').with(
            :future_parser     => false,
            :environmentpath   =>"/etc/puppet/environments",
            :extra_module_path => "/etc/puppet/site:/usr/share/puppet/modules",
            :autosign          => false
          ).that_comes_before('Class[puppet::master::hiera]')

          should contain_class('puppet::master::hiera').with(
            :hiera_backends  => {"yaml"=>{"datadir"=>"/etc/puppet/hiera/%{environment}"}},
            :hiera_hierarchy => ["node/%{::clientcert}", "env/%{::environment}", "global"],
            :hieradata_path  => "/etc/puppet/hiera",
            :env_owner       => "puppet",
            :eyaml_keys      => false
          ).that_notifies('Class[Puppet::Master::Passenger]')

          should contain_class('puppet::master::passenger').with(
            :passenger_max_pool_size      =>"12",
            :passenger_pool_idle_time     =>"1500",
            :passenger_stat_throttle_rate => "120",
            :passenger_max_requests       => "0"
          )

          should_not contain_class('puppet::master::ssl')
        end
      end#no params

      context 'autosign => true' do
        let (:params) {{ :autosign => true }}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::config').with(
            :autosign => true)
        end
      end#autosign

      context 'dns_alt_names => [foo, bar, baz]' do
        let (:params) {{ :dns_alt_names => [ 'foo', 'bar', 'baz' ] }}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::config').with(
            :dns_alt_names => [ 'foo', 'bar', 'baz' ])
        end
      end#dns_alt_names

      context 'env_owner => foo' do
        let (:params) {{ :env_owner => 'foo' }}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::hiera').with(
            :env_owner => 'foo')
        end
      end#env_owner

      context 'environmentpath => /BOGON' do
        let (:params) {{ :environmentpath => '/BOGON' }}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::config').with(
            :environmentpath => '/BOGON')
        end
      end#environmentpath

      context 'eyaml_keys => true' do
        let (:params) {{ :eyaml_keys => true}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::hiera').with(
            :eyaml_keys => true)
        end
      end#eyaml_keys

      context 'future_parser => true' do
        let (:params) {{ :future_parser => true }}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::config').with(
            :future_parser => true)
        end
      end#future_parser

      context 'hiera_backends => { :yaml => { :datadir => BOGON } } }' do
        let (:params) {{ :hiera_backends => { 'yaml' => { 'datadir' => 'BOGON' } } } }
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::hiera').with(
            :hiera_backends => { 'yaml' => { 'datadir' => 'BOGON' }})
        end
      end#hiera_backends

      context 'when the hiera_eyaml_version parameter has a custom value' do
        let (:params) {{ :hiera_eyaml_version => 'BOGON'}}
        it 'should properly instantiate the puppet::master::install class' do
          should contain_class('puppet::master::install').with(
            :hiera_eyaml_version=>"BOGON")
        end
      end#hiera_eyaml_version

      context 'hiera_hierarchy => [foo, bar, baz]}' do
        let (:params) {{ :hiera_hierarchy => ['foo', 'bar', 'baz']}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::hiera').with(
            :hiera_hierarchy=>['foo', 'bar', 'baz'])
        end
      end#hiera_hierarchy

      context 'hieradata_path => /BOGON' do
        let (:params) {{ :hieradata_path => '/BOGON' }}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::hiera').with(
            :hieradata_path => '/BOGON')
        end
      end#hieradatata_path

      context 'manage_ssl => true ... with fake cert/key/pass' do
        let(:params) {{
          :manage_ssl     => true,
          :puppet_ca_cert => 'cert',
          :puppet_ca_key  => 'key',
          :puppet_ca_pass => 'pass',
          :puppet_fqdn    => 'puppet.test.com'
        }}
        it do
          should compile.with_all_deps
          should compile.with_all_deps
          should contain_class('puppet::master::ssl').with(
            :puppet_ca_cert => 'cert',
            :puppet_ca_key  => 'key',
            :puppet_ca_pass => 'pass',
            :puppet_fqdn    => 'puppet.test.com')
        end
      end#manage_ssl

      context 'module_path => BOGON' do
        let (:params) {{ :module_path => 'BOGON'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::config').with(
            :extra_module_path=>'BOGON')
        end
      end#module_path

      context 'passenver_max_pool_size => BOGON' do
        let (:params) {{ :passenger_max_pool_size => 'BOGON'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::passenger').with(
            :passenger_max_pool_size => 'BOGON')
        end
      end#passenger_max_pool_size

      context 'passenger_max_requests => BOGON' do
        let (:params) {{ :passenger_max_requests => 'BOGON'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::passenger').with(
            :passenger_max_requests => 'BOGON')
        end
      end#passenger_max_requests

      context 'passenger_pool_idle_time => BOGON' do
        let (:params) {{ :passenger_pool_idle_time => 'BOGON'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::passenger').with(
            :passenger_pool_idle_time => 'BOGON')
        end
      end#passenger_pool_idle_time

      context 'passenger_stat_throttle_rate => BOGON' do
        let (:params) {{ :passenger_stat_throttle_rate => 'BOGON'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::passenger').with(
            :passenger_stat_throttle_rate => 'BOGON')
        end
      end#passenger_stat_throttle_rate

      context 'pre_module_path => BOGON' do
        let (:params) {{ :pre_module_path => 'BOGON'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::config').with(
            :extra_module_path => 'BOGON:/etc/puppet/site:/usr/share/puppet/modules')
        end
      end#pre_module_path

      context 'pre_module_path => BOGON:' do
        let (:params) {{ :pre_module_path => 'BOGON:'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::config').with(
            :extra_module_path=>'BOGON:/etc/puppet/site:/usr/share/puppet/modules')
        end
      end#pre_module_path

      context 'puppet_fqdn => BOGON, manage_ssl => true' do
        let (:params) {{
          :puppet_fqdn => 'BOGON',
          :manage_ssl  => true
        }}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::config').with(
            :puppet_fqdn => 'BOGON')
          should contain_class('puppet::master::ssl').with(
            :puppet_fqdn => 'BOGON')
          should contain_class('puppet::master::passenger').with(
            :puppet_fqdn => 'BOGON')
        end
      end#puppet_fqdn

      context 'when the puppet_version parameter has a custom value' do
        let (:params) {{ :puppet_version => 'BOGON'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::install').with(
            :puppet_version=>'BOGON')
        end
      end#puppet_version

      context 'when the r10k_version parameter has a custom value' do
        let (:params) {{ :r10k_version => 'BOGON'}}
        it do
          should compile.with_all_deps
          should contain_class('puppet::master::install').with(
            :r10k_version=>'BOGON')
        end
      end#r10k_version

    end
  end
end
