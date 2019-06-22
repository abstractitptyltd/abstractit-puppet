#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::profile::master', :type => :class do
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
            "6",
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
      # it { is_expected.to compile.with_all_deps }
      confdir        = '/etc/puppetlabs/puppet'
      codedir        = '/etc/puppetlabs/code'
      context 'when fed no parameters' do
        it { should create_class('puppet::master') }
        it 'should contain class ::puppetdb::globals' do
          should contain_class('puppetdb::globals').with({
            :version => 'installed'
          })
        end
      end#no params

      context 'when puppetdb is true and puppetdb_manage_dbserver is unspecified' do
        let(:pre_condition){"class{'::puppet::profile::master': puppetdb => true}"}
        it 'should contain class ::puppetdb' do
          should contain_class('puppetdb').with({
            :listen_port        => '8080',
            :ssl_listen_port    => '8081',
            :disable_ssl        => false,
            :manage_dbserver    => true,
            :listen_address     => '127.0.0.1',
            :ssl_listen_address => '0.0.0.0',
            :node_ttl           => '0s',
            :node_purge_ttl     => '0s',
            :report_ttl         => '14d',
          })
        end
      end
      context 'when puppetdb is true and puppetdb_manage_dbserver is false' do
        let(:pre_condition) do
          "class{'::puppet::profile::master': puppetdb => true, puppetdb_manage_dbserver => false} class{'::postgresql::server':}"
        end
        it 'should contain class ::puppetdb' do
          should contain_class('puppetdb').with({
            :listen_port        => '8080',
            :ssl_listen_port    => '8081',
            :disable_ssl        => false,
            :manage_dbserver    => false,
            :listen_address     => '127.0.0.1',
            :ssl_listen_address => '0.0.0.0',
            :node_ttl           => '0s',
            :node_purge_ttl     => '0s',
            :report_ttl         => '14d',
          })
        end
      end

      context 'when puppetdb_server is set' do
        let(:pre_condition){"class{'::puppet::profile::master': puppetdb_server => 'puppetdb.vogon.gal'}"}
        it 'should contain class puppetdb::master::config' do
          should contain_class('puppetdb::master::config').with({
            :puppetdb_port           => '8081',
            :puppetdb_server         => 'puppetdb.vogon.gal',
            :puppet_service_name     => 'httpd',
            :enable_reports          => true,
            :manage_report_processor => true,
            :restart_puppet          => true,
          })
        end
        # it 'should contain class puppetdb::master::puppetdb_conf' do
        #   should contain_class('puppetdb::master::puppetdb_conf').with({
        #     :port            => '8081',
        #     :puppet_confdir  => "#{confdir}",
        #     :legacy_terminus => "#{terminus_package}",
        #   })
        # end
      end# puppetdb
    end
  end
end
