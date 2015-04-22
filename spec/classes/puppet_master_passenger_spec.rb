#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::passenger', :type => :class do
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :fqdn => 'constructorfleet.vogon.gal',
          :domain => 'vogon.gal',
        })
      end
      let(:pre_condition){"class{'puppet::master::install':}"}
      context 'when fed no parameters' do
        it 'should properly instantiate the apache class' do
          should contain_class('Apache').with({
            'mpm_module'=>'worker',
            'default_vhost'=>false,
            'serveradmin'=>'webmaster@vogon.gal',
            :default_mods=>false
          })
        end
        case facts[:lsbdistcodename]
        when 'trusty'
          it 'should properly instantiate the apache module "access_compat"' do
            skip 'This does not work as is'
            should contain_apache__mod('access_compat').with({
#              'name'=>"access_compat",
              'package_ensure'=>'undef'
            })
          end
        end

        it 'should properly instantiate the apache::mod::passenger class' do
          should contain_class('apache::mod::passenger').with({
            :passenger_high_performance=>"On",
            :passenger_max_pool_size=>"12",
            :passenger_pool_idle_time=>"1500",
            :passenger_stat_throttle_rate=>"120",
            :passenger_max_requests=>"0",
            :passenger_conf_file=>"passenger.conf"
          })
          end
  
        it 'should set up the apache vhost' do
#          skip 'This does not work as is'
          case facts['lsbdistcodename']
          when 'trusty'  
            should contain_apache__vhost('constructorfleet.vogon.gal').with({
              :name=>"constructorfleet.vogon.gal",
              :docroot=>"/usr/share/puppet/rack/puppetmasterd/public/",
              :docroot_owner=>"root",
              :docroot_group=>"root",
              :passenger_app_root=>"/usr/share/puppet/rack/puppetmasterd",
              :port=>"8140",
              :ssl=>true,
              :ssl_crl_check=>'chain',
              :ssl_cert=>"/var/lib/puppet/ssl/certs/constructorfleet.vogon.gal.pem",
              :ssl_key=>"/var/lib/puppet/ssl/private_keys/constructorfleet.vogon.gal.pem",
              :ssl_chain=>"/var/lib/puppet/ssl/certs/ca.pem",
              :ssl_ca=>"/var/lib/puppet/ssl/certs/ca.pem",
              :ssl_crl=>"/var/lib/puppet/ssl/ca/ca_crl.pem",
              :ssl_certs_dir=>"/var/lib/puppet/ssl/certs",
              :ssl_verify_client=>"optional",
              :ssl_verify_depth=>"1",
              :ssl_options=>["+StdEnvVars", "+ExportCertData"],
              :rack_base_uris=>"/",
              :directories=>{"path"=>"/usr/share/puppet/rack/puppetmasterd/", "options"=>"None"},
              :request_headers=>["unset X-Forwarded-For", "set X-SSL-Subject %{SSL_CLIENT_S_DN}e", "set X-Client-DN %{SSL_CLIENT_S_DN}e", "set X-Client-Verify %{SSL_CLIENT_VERIFY}e"]
              }).that_subscribes_to('Class[Puppet::Master::Install]')
          when 'precise'
            should contain_apache__vhost('constructorfleet.vogon.gal').with({
              :name=>"constructorfleet.vogon.gal",
              :docroot=>"/usr/share/puppet/rack/puppetmasterd/public/",
              :docroot_owner=>"root",
              :docroot_group=>"root",
              :passenger_app_root=>"/usr/share/puppet/rack/puppetmasterd",
              :port=>"8140",
              :ssl=>true,
              :ssl_crl_check=>'chain',
              :ssl_cert=>"/var/lib/puppet/ssl/certs/constructorfleet.vogon.gal.pem",
              :ssl_key=>"/var/lib/puppet/ssl/private_keys/constructorfleet.vogon.gal.pem",
              :ssl_chain=>"/var/lib/puppet/ssl/certs/ca.pem",
              :ssl_ca=>"/var/lib/puppet/ssl/certs/ca.pem",
              :ssl_crl=>"/var/lib/puppet/ssl/ca/ca_crl.pem",
              :ssl_certs_dir=>"/var/lib/puppet/ssl/certs",
              :ssl_verify_client=>"optional",
              :ssl_verify_depth=>"1",
              :ssl_options=>["+StdEnvVars", "+ExportCertData"],
              :rack_base_uris=>"/",
              :directories=>{"path"=>"/usr/share/puppet/rack/puppetmasterd/", "options"=>"None"},
              :request_headers=>["unset X-Forwarded-For", "set X-SSL-Subject %{SSL_CLIENT_S_DN}e", "set X-Client-DN %{SSL_CLIENT_S_DN}e", "set X-Client-Verify %{SSL_CLIENT_VERIFY}e"]
              }).that_subscribes_to('Class[Puppet::Master::Install]')
          end
        end
      end#no params
      context 'when passenger_max_pool_size has a non-standard value' do
        let(:pre_condition){"class{'::puppet::master': passenger_max_pool_size => 'BOGON'}"}
        it 'should properly instantiate the apache::mod::passenger class' do
          should contain_class('apache::mod::passenger').with({
            :passenger_high_performance=>"On",
            :passenger_max_pool_size=>"BOGON",
            :passenger_pool_idle_time=>"1500",
            :passenger_stat_throttle_rate=>"120",
            :passenger_max_requests=>"0",
            :passenger_conf_file=>"passenger.conf"
          })
        end
      end#end passenger_max_pool_size

      context 'when passenger_max_requests has a non-standard value' do
        let(:pre_condition){"class{'::puppet::master': passenger_max_requests => 'BOGON'}"}
        it 'should properly instantiate the apache::mod::passenger class' do
          should contain_class('apache::mod::passenger').with({
            :passenger_high_performance=>"On",
            :passenger_max_pool_size=>"12",
            :passenger_pool_idle_time=>"1500",
            :passenger_stat_throttle_rate=>"120",
            :passenger_max_requests=>"BOGON",
            :passenger_conf_file=>"passenger.conf"
          })
        end
      end#end passenger_max_requests

      context 'when passenger_pool_idle_time has a non-standard value' do
        let(:pre_condition){"class{'::puppet::master': passenger_pool_idle_time => 'BOGON'}"}
        it 'should properly instantiate the apache::mod::passenger class' do
          should contain_class('apache::mod::passenger').with({
            :passenger_high_performance=>"On",
            :passenger_max_pool_size=>"12",
            :passenger_pool_idle_time=>"BOGON",
            :passenger_stat_throttle_rate=>"120",
            :passenger_max_requests=>"0",
            :passenger_conf_file=>"passenger.conf"
          })
        end
      end#end passenger_pool_idle_time

      context 'when passenger_stat_throttle_rate has a non-standard value' do
        let(:pre_condition){"class{'::puppet::master': passenger_stat_throttle_rate => 'BOGON'}"}
        it 'should properly instantiate the apache::mod::passenger class' do
          should contain_class('apache::mod::passenger').with({
            :passenger_high_performance=>"On",
            :passenger_max_pool_size=>"12",
            :passenger_pool_idle_time=>"1500",
            :passenger_stat_throttle_rate=>"BOGON",
            :passenger_max_requests=>"0",
            :passenger_conf_file=>"passenger.conf"
          })
        end
      end#end passenger_stat_throttle_rate

      context 'when puppet_fqdn has a non-standard value' do
        let(:pre_condition){"class{'::puppet::master': puppet_fqdn => 'BOGON'}"}
        it 'should properly instantiate the apache::vhost defined type' do
          should contain_apache__vhost('BOGON').with({
            :name=>"BOGON",
            :ssl_cert=>"/var/lib/puppet/ssl/certs/BOGON.pem",
            :ssl_key=>"/var/lib/puppet/ssl/private_keys/BOGON.pem",
          })
        end
      end#end puppet_fqdn

    end#each OS
#    context '[Debian - unspecific]' do
#      let(:facts) {{'fqdn' => 'constructorfleet.vogon.gal','lsbdistcodename' => 'squeeze', 'osfamily' => osfam, 'operatingsystemrelease' => '6.06','concat_basedir' => '/tmp'}}
#      it 'should not add the SSLCARevocationCheck chain to the apache vhost config' do
#        skip 'This does not work as is'
#        should contain_apache__vhost('constructorfleet.vogon.gal').without({
#          :contents=>/SSLCARevocationCheck chain/
#        })
#      end
#    end
  end # on_supported_os
end

