#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::profile::puppetdb', :type => :class do
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
      # it { is_expected.to compile.with_all_deps }
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
            :manage_dbserver    => true,
            :node_ttl           => '0s',
            :node_purge_ttl     => '0s',
            :report_ttl         => '14d',
          })
        end
      end#no params

    end
  end
end
