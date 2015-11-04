#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::profile::puppetdb', :type => :class do
  context 'input validation' do

    # ['foo'].each do |paths|
    #   context "when the #{paths} parameter is not an absolute path" do
    #     let(:params) {{ paths => 'foo' }}
    #     it 'should fail' do
    #       skip 'This does not work as is'
    #       expect { subject }.to raise_error(Puppet::Error)#, /"foo" is not an absolute path/)
    #     end
    #   end
    # end#absolute path

    # ['array'].each do |arrays|
    #   context "when the #{arrays} parameter is not an array" do
    #     let(:params) {{ arrays => 'this is a string'}}
    #     it 'should fail' do
    #       skip 'This does not work as is'
    #        expect { subject }.to raise_error(Puppet::Error)#, /is not an Array./)
    #     end
    #   end
    # end#arrays

    ['reports','use_ssl'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let(:params) {{bools => "BOGON"}}
        it 'should fail' do
          skip 'This does not work as is'
          expect { subject }.to raise_error(Puppet::Error)#, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end#bools

    # ['foo_hash'].each do |hashes|
    #   context "when the #{hashes} parameter is not an hash" do
    #     let(:params) {{ hashes => 'this is a string'}}
    #     it 'should fail' do
    #       skip 'This does not work as is'
    #        expect { subject }.to raise_error(Puppet::Error)#, /is not a Hash./)
    #     end
    #   end
    # end#hashes

    ['puppetdb_version','node_purge_ttl','node_ttl','puppetdb_listen_address','puppetdb_server','puppetdb_ssl_listen_address','report_ttl','listen_port','ssl_listen_port','puppet_server_type'].each do |strings|
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
          :fqdn           => 'constructorfleet.vogon.gal',
          :domain         => 'vogon.gal',
          :puppetversion  => Puppet.version
        })
      end
      it { is_expected.to compile.with_all_deps }
      if Puppet.version.to_f >= 4.0
        confdir           = '/etc/puppetlabs/puppet'
        codedir           = '/etc/puppetlabs/code'
        terminus_package  = 'puppetdb-termini'
        puppetdb_confdir  = '/etc/puppetlabs/puppetdb/conf.d'
        puppetdb_ssldir   = '/etc/puppetlabs/puppetdb/ssl'
        puppetdb_test_url = '/pdb/meta/v1/version'
      else
        confdir          = '/etc/puppet'
        codedir          = '/etc/puppet'
        terminus_package = 'puppetdb-terminus'
        puppetdb_confdir  = '/etc/puppetdb/conf.d'
        puppetdb_ssldir   = '/etc/puppetdb/ssl'
        puppetdb_test_url = '/v3/version'
      end

      context 'when fed no parameters' do
        # it 'should include class ::postgresql::server::contrib' do
        #   should include_class('::postgresql::server::contrib')
        # end
        # it 'should setup pg_trgm extension' do
        #   should contain_postgresql__server__extension('pg_trgm').with({
        #     :database => 'puppetdb'
        #   })
        # end
        it 'should contain class ::puppetdb::globals' do
          should contain_class('puppetdb::globals').with({
            :version => 'installed'
          })
        end
        it 'should contain class ::puppetdb' do
          should contain_class('puppetdb').with({
            :listen_port        => '8080',
            :ssl_listen_port    => '8081',
            :disable_ssl        => false,
            :listen_address     => '127.0.0.1',
            :ssl_listen_address => '0.0.0.0',
            :node_ttl           => '0s',
            :node_purge_ttl     => '0s',
            :report_ttl         => '14d',
            :confdir            => "#{puppetdb_confdir}",
            :ssl_dir            => "#{puppetdb_ssldir}",
          })
        end
        it 'should contain class puppetdb::master::config' do
          should contain_class('puppetdb::master::config').with({
            :manage_config           => false,
            :test_url                => "#{puppetdb_test_url}",
            :puppetdb_port           => '8081',
            :puppetdb_server         => 'puppet.vogon.gal',
            :puppet_service_name     => 'httpd',
            :enable_reports          => true,
            :manage_report_processor => true,
            :restart_puppet          => true,
          })
        end
        it 'should contain class puppetdb::master::puppetdb_conf' do
          should contain_class('puppetdb::master::puppetdb_conf').with({
            :port            => '8081',
            :puppet_confdir  => "#{confdir}",
            :legacy_terminus => "#{terminus_package}",
          })
        end
      end#no params

    end
  end
end
