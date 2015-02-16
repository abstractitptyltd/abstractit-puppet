#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'
describe 'puppet::master::puppetdb', :type => :class do
  let(:default_params) {{'puppetdb_version' => 'installed'}}
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
    ['reports','use_ssl'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let(:params) {default_params.merge({bools => "BOGON"})}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end#bools
#    ['hash'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let(:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes
#    ['opt_hash'].each do |opt_hashes|
#      context "when the optional param #{opt_hashes} parameter has a value, but not a hash" do
#        let(:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#opt_hashes
    ['node_purge_ttl','node_ttl','puppetdb_listen_address','puppetdb_server','puppetdb_ssl_listen_address','puppetdb_version','report_ttl'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let(:params) {default_params.merge({strings => false })}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings
#    ['opt_strings'].each do |optional_strings|
#      context "when the optional parameter #{optional_strings} has a value, but it is not a string" do
#        let(:params) {{optional_strings => true }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /true is not a string./)
#        end
#      end
#    end#opt_strings
  end#input validation

  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts
      end
      let:facts do
      {
        :concat_basedir => '/tmp',
        :domain => 'domain.com'
      }
      end
      let(:pre_condition){"class{'puppet::master':}"}
      context 'when fed no parameters' do
        let(:params){default_params}
        it 'should properly instantiate the puppetdb class' do
          should contain_class('puppetdb').with({
            :name=>"Puppetdb",
            :disable_ssl=>false,
            :listen_address=>"127.0.0.1",
            :ssl_listen_address=>"127.0.0.1",
            :node_ttl=>"0s",
            :node_purge_ttl=>"0s",
            :report_ttl=>"14d",
            :puppetdb_version=>"installed",
          }).that_requires('class[puppet::master]')
        end
        it 'should properly instantiate the puppetdb::master::config class' do
          should contain_class('puppetdb::master::config').with({
            :name=>"Puppetdb::Master::Config",
            :puppetdb_port=>"8081",
            :puppetdb_server=>"puppet.domain.com",
            :puppet_service_name=>"httpd",
            :enable_reports=>true,
            :manage_report_processor=>true,
            :restart_puppet=>true,
            :puppetdb_version=>"installed",
          }).that_requires('class[puppet::master::puppetdb]')
        end

        it 'should create the \'puppet clean reports\' cronjob' do
          should contain_cron('puppet clean reports').with({
            :name=>"puppet clean reports",
            :command=>"cd /var/lib/puppet/reports && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f",
            :user=>"root",
            :hour=>"21",
            :minute=>"22",
            :weekday=>"0"
          })
        end
      end#no params
      context 'when puppetdb_version has a non-standard value' do
        let(:params){default_params.merge({'puppetdb_version' => 'BOGON'})}
        it 'should instantiate the puppetdb class apropriately' do
          should contain_class('Puppetdb').with({
            :name=>"Puppetdb",
            :disable_ssl=>false,
            :listen_address=>"127.0.0.1",
            :ssl_listen_address=>"127.0.0.1",
            :node_ttl=>"0s",
            :node_purge_ttl=>"0s",
            :report_ttl=>"14d",
            :puppetdb_version=>"BOGON",
          }).that_requires('class[Puppet::Master]')
        end
        it 'should instantiate the puppetdb::master::config class apropriately' do
          should contain_class('Puppetdb::Master::Config').with({
            :puppetdb_port=>"8081",
            :puppetdb_server=>"puppet.domain.com",
            :puppet_service_name=>"httpd",
            :enable_reports=>true,
            :manage_report_processor=>true,
            :restart_puppet=>true,
            :puppetdb_version=>"BOGON",
          })
        end
      end#end puppetdb_version
      context 'when node_purge_ttl has a non-standard value' do
        let(:params){default_params.merge({'node_purge_ttl' => '999d'})}
        it 'should instantiate the puppetdb class apropriately' do
          should contain_class('Puppetdb').with({:name=>"Puppetdb",
            :disable_ssl=>false,
            :listen_address=>"127.0.0.1",
            :ssl_listen_address=>"127.0.0.1",
            :node_ttl=>"0s",
            :node_purge_ttl=>"999d",
            :report_ttl=>"14d",
            :puppetdb_version=>"installed",
          }).that_requires('class[Puppet::Master]')
        end
      end#end node_purge_ttl
      context 'when node_ttl has a non-standard value' do
        let(:params){default_params.merge({'node_ttl' => '888d'})}
        it 'should instantiate the puppetdb class apropriately' do
          should contain_class('Puppetdb').with({
            :name=>"Puppetdb",
            :disable_ssl=>false,
            :listen_address=>"127.0.0.1",
            :ssl_listen_address=>"127.0.0.1",
            :node_ttl=>"888d",
            :node_purge_ttl=>"0s",
            :report_ttl=>"14d",
            :puppetdb_version=>"installed",
          }).that_requires('class[Puppet::Master]')
        end
      end#end node_ttl
      context 'when puppetdb_listen_address has a non-standard value' do
        let(:params){default_params.merge({'puppetdb_listen_address' => 'BOGON'})}
        it 'should instantiate the puppetdb class apropriately' do
          should contain_class('Puppetdb').with({
            :name=>"Puppetdb",
            :disable_ssl=>false,
            :listen_address=>"BOGON",
            :ssl_listen_address=>"127.0.0.1",
            :node_ttl=>"0s",
            :node_purge_ttl=>"0s",
            :report_ttl=>"14d",
            :puppetdb_version=>"installed",
          }).that_requires('class[Puppet::Master]')
        end
      end#end puppetdb_listen_address
      context 'when puppetdb_server has a non-standard value' do
        let(:params){default_params.merge({'puppetdb_server' => 'BOGON'})}
        it 'should instantiate the puppetdb::master::config class apropriately' do
          should contain_class('Puppetdb::Master::Config').with({
            :name=>"Puppetdb::Master::Config",
            :puppetdb_port=>"8081",
            :puppetdb_server=>"BOGON",
            :puppet_service_name=>"httpd",
            :enable_reports=>true,
            :manage_report_processor=>true,
            :restart_puppet=>true,
            :puppetdb_version=>"installed",
          }).that_requires('class[Puppet::Master::Puppetdb]')
        end
      end#end puppetdb_server
      context 'when puppetdb_ssl_listen_address has a non-standard value' do
        let(:params){default_params.merge({'puppetdb_ssl_listen_address' => 'BOGON'})}
        it 'should instantiate the puppetdb class apropriately' do
          should contain_class('Puppetdb').with({
            :name=>"Puppetdb",
            :disable_ssl=>false,
            :listen_address=>"127.0.0.1",
            :ssl_listen_address=>"BOGON",
            :node_ttl=>"0s",
            :node_purge_ttl=>"0s",
            :report_ttl=>"14d",
            :puppetdb_version=>"installed",
          }).that_requires('class[Puppet::Master]')
        end
      end#end puppetdb_ssl_listen_address
      context 'when puppetdb_server has a non-standard value' do
        let(:params){default_params.merge({'puppetdb_server' => 'BOGON'})}
        it 'should instantiate the puppetdb::master::config class apropriately' do
          should contain_class('Puppetdb::Master::Config').with({
            :name=>"Puppetdb::Master::Config",
            :puppetdb_port=>"8081",
            :puppetdb_server=>"BOGON",
            :puppet_service_name=>"httpd",
            :enable_reports=>true,
            :manage_report_processor=>true,
            :restart_puppet=>true,
            :puppetdb_version=>"installed",
          }).that_requires('class[Puppet::Master::Puppetdb]')
        end
      end#end puppetdb_server
      context 'when reports is false' do
        let(:params){default_params.merge({'reports' => false})}
        it 'should instantiate the puppetdb::master::config class apropriately' do
          should contain_class('Puppetdb::Master::Config').with({
            :name=>"Puppetdb::Master::Config",
            :puppetdb_port=>"8081",
            :puppetdb_server=>"puppet.domain.com",
            :puppet_service_name=>"httpd",
            :enable_reports=>false,
            :manage_report_processor=>false,
            :restart_puppet=>true,
            :puppetdb_version=>"installed",
          }).that_requires('class[Puppet::Master::Puppetdb]')
        end
      end#end reports
      context 'when use_ssl is false' do
        let(:params){default_params.merge({'use_ssl' => false})}
        it 'should properly instantiate the puppetdb class' do
          should contain_class('Puppetdb').with({
            :name=>"Puppetdb",
            :disable_ssl=>true,
            :listen_address=>"127.0.0.1",
            :ssl_listen_address=>"127.0.0.1",
            :node_ttl=>"0s",
            :node_purge_ttl=>"0s",
            :report_ttl=>"14d",
            :puppetdb_version=>"installed",
            :listen_port=>"8080",
            :open_listen_port=>false,
            :ssl_listen_port=>"8081",
            :manage_dbserver=>true,
            :database=>"postgres",
            :database_port=>"5432",
            :database_username=>"puppetdb",
            :database_password=>"puppetdb",
            :database_name=>"puppetdb",
            :database_ssl=>false,
            :database_listen_address=>"localhost",
            :gc_interval=>"60",
            :log_slow_statements=>"10",
            :conn_max_age=>"60",
            :conn_keep_alive=>"45",
            :conn_lifetime=>"0",
            :puppetdb_package=>"puppetdb",
            :puppetdb_service=>"puppetdb",
            :puppetdb_service_status=>"running",
            :confdir=>"/etc/puppetdb/conf.d",
            :java_args=>{},
          }).that_requires('class[Puppet::Master]')
        end
        it 'should instantiate the puppetdb::master::config class apropriately' do
         should contain_class('Puppetdb::Master::Config').with({
            :name=>"Puppetdb::Master::Config",
            :puppetdb_port=>"8080",
            :puppetdb_server=>"puppet.domain.com",
            :puppet_service_name=>"httpd",
            :enable_reports=>true,
            :manage_report_processor=>true,
            :restart_puppet=>true,
            :puppetdb_version=>"installed",
          }).that_requires('class[Puppet::Master::Puppetdb]')
        end
      end#end use_ssl
    end#debian
  end# supported OS
end