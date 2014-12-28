#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::passenger', :type => :class do
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

#    ['bool'].each do |bools|
#      context "when the #{bools} parameter is not an boolean" do
#        let(:params) {{bools => "BOGON"}}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
#        end
#      end
#    end#bools

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


    ['passenger_max_pool_size','passenger_max_requests','passenger_pool_idle_time','passenger_stat_throttle_rate','puppet_fqdn'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let(:params) {{strings => false }}
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
  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      context '[ubuntu trusty]' do
        let(:facts) {{'fqdn' => 'constructorfleet.vogon.gal','lsbdistcodename' => 'trusty', 'osfamily' => osfam, 'operatingsystemrelease' => '14.04','concat_basedir' => '/tmp'}}
        let(:pre_condition) {"class{'puppet::master::install': hiera_eyaml_version=>'present' }"}
        context 'when fed no parameters' do
          it 'should properly instantiate the apache class' do
            should contain_class('Apache').with({
              :apache_version=>"2.2",
              :conf_template=>"apache/httpd.conf.erb",
              :confd_dir=>"/etc/apache2/conf.d",
              :default_confd_files=>true,
              :default_mods=>false,
              :default_ssl_cert=>"/etc/ssl/certs/ssl-cert-snakeoil.pem",
              :default_ssl_key=>"/etc/ssl/private/ssl-cert-snakeoil.key",
              :default_ssl_vhost=>false,
              :default_vhost=>false,
              :error_documents=>false,
              :group=>"www-data",
              :httpd_dir=>"/etc/apache2",
              :keepalive=>"Off",
              :keepalive_timeout=>"15",
              :log_formats=>{},
              :log_level=>"warn",
              :logroot=>"/var/log/apache2",
              :manage_group=>true,
              :manage_user=>true,
              :max_keepalive_requests=>"100",
              :mod_dir=>"/etc/apache2/mods-available",
              :mod_enable_dir=>"/etc/apache2/mods-enabled",
              :mpm_module=>"worker",
              :name=>"Apache",
              :package_ensure=>"installed",
              :ports_file=>"/etc/apache2/ports.conf",
              :purge_configs=>true,
              :sendfile=>"On",
              :server_root=>"/etc/apache2",
              :server_signature=>"On",
              :server_tokens=>"OS",
              :servername=>'constructorfleet.vogon.gal',
              :service_enable=>true,
              :service_ensure=>"running",
              :service_name=>"apache2",
              :timeout=>"120",
              :trace_enable=>"On",
              :user=>"www-data",
              :vhost_dir=>"/etc/apache2/sites-available",
              :vhost_enable_dir=>"/etc/apache2/sites-enabled",
            })
          end
          it 'should properly instantiate the apache module "access_compat"' do
            should contain_apache__mod('access_compat').with({
              :name=>"access_compat",
              :package_ensure=>"present",
              :lib_path=>"/usr/lib/apache2/modules"
            })
          end

          it 'should properly instantiate the apache::mod::passenger class' do
            should contain_class('Apache::Mod::Passenger').with({
              :passenger_high_performance=>"On",
              :passenger_max_pool_size=>"12",
              :passenger_pool_idle_time=>"1500",
              :passenger_stat_throttle_rate=>"120",
              :passenger_max_requests=>"0",
              :passenger_conf_file=>"passenger.conf"
            })
          end

          it 'should set up the apache vhost' do
            should contain_apache__vhost('constructorfleet.vogon.gal').with({
              :name=>"constructorfleet.vogon.gal",
              :docroot=>"/usr/share/puppet/rack/puppetmasterd/public/",
              :docroot_owner=>"root",
              :docroot_group=>"root",
              :port=>"8140",
              :ssl=>true,
              :ssl_protocol=>"ALL -SSLv2",
              :ssl_cipher=>"ALL:!aNULL:!eNULL:!DES:!3DES:!IDEA:!SEED:!DSS:!PSK:!RC4:!MD5:+HIGH:+MEDIUM:!LOW:!SSLv2:!EXP",
              :ssl_honorcipherorder=>"on",
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
              :custom_fragment=>"  SSLCARevocationCheck chain\n  PassengerAppRoot /usr/share/puppet/rack/puppetmasterd\n  PassengerRoot /usr/lib/passenger",
              :request_headers=>["unset X-Forwarded-For", "set X-SSL-Subject %{SSL_CLIENT_S_DN}e", "set X-Client-DN %{SSL_CLIENT_S_DN}e", "set X-Client-Verify %{SSL_CLIENT_VERIFY}e"]
              }).that_subscribes_to('Class[Puppet::Master::Install]')
          end
        end#no params
        context 'when passenger_max_pool_size has a non-standard value' do
          let(:params){{'passenger_max_pool_size' => 'BOGON'}}
          it 'should properly instantiate the apache::mod::passenger class' do
            should contain_class('Apache::Mod::Passenger').with({
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
          let(:params){{'passenger_max_requests' => 'BOGON'}}
          it 'should properly instantiate the apache::mod::passenger class' do
            should contain_class('Apache::Mod::Passenger').with({
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
          let(:params){{'passenger_pool_idle_time' => 'BOGON'}}
          it 'should properly instantiate the apache::mod::passenger class' do
            should contain_class('Apache::Mod::Passenger').with({
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
          let(:params){{'passenger_stat_throttle_rate' => 'BOGON'}}
          it 'should properly instantiate the apache::mod::passenger class' do
            should contain_class('Apache::Mod::Passenger').with({
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
          let(:params){{'puppet_fqdn' => 'BOGON'}}
          it 'should properly instantiate the apache::vhost defined type' do
            should contain_apache__vhost('BOGON').with({
              :name=>"BOGON",
              :ssl_cert=>"/var/lib/puppet/ssl/certs/BOGON.pem",
              :ssl_key=>"/var/lib/puppet/ssl/private_keys/BOGON.pem",
            })
          end
        end#end puppet_fqdn


      end#trusty
      context '[Debian - unspecific]' do
        let(:facts) {{'fqdn' => 'constructorfleet.vogon.gal','lsbdistcodename' => 'squeeze', 'osfamily' => osfam, 'operatingsystemrelease' => '6.06','concat_basedir' => '/tmp'}}
        it 'should not add the SSLCARevocationCheck chain to the apache vhost config' do
          should contain_apache__vhost('constructorfleet.vogon.gal').without({
            :custom_fragment=>/SSLCARevocationCheck chain/
          })
        end
      end
    end
  end
end
