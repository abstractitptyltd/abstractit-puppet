#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::hiera', :type => :class do
  context 'input validation' do

#    let(:default_params) {{'hiera_backends' => {'yaml' => { 'datadir' => '/etc/puppet/hiera/%{environment}',} } }}
#    ['hieradata_path'].each do |paths|
#      context "when the #{paths} parameter is not an absolute path" do
#        let(:params) {{ paths => 'foo' }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
#        end
#      end
#    end#absolute path

#    ['hierarchy'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let(:params){default_params.merge({ arrays => 'this is a string'})}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not an Array./)
#        end
#      end
#    end#arrays

#    ['eyaml_keys'].each do |bools|
#      context "when the #{bools} parameter is not an boolean" do
#        let(:params){default_params.merge({bools => "BOGON"})}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
#        end
#      end
#    end#bools

#    ['hiera_backends'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let(:params){default_params.merge({ hashes => 'this is a string'})}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes

#    ['env_owner'].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let(:params){default_params.merge({strings => false })}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
#        end
#      end
#    end#strings

  end#input validation

  #  ['Debian'].each do |osfam|
  #    context "When on an #{osfam} system" do
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts
      end
      let:facts do
      {
        :concat_basedir => '/tmp'
      }
      end
      let(:pre_condition){"class{'apache':}"}
#      let(:default_params) {{'hiera_backends' => {'yaml' => { 'datadir' => '/etc/puppet/hiera/%{environment}',} } }}
      let(:pre_condition) {"class{'::puppet::master': hiera_backends => {'yaml' => { datadir => '/etc/puppet/hiera/%{environment}}'}"}

      context 'when fed no parameters' do
#        let(:params){default_params}
        it 'should lay down /etc/hiera.yaml' do
          should contain_file('/etc/hiera.yaml').with({
            :path=>"/etc/hiera.yaml",
            :ensure=>"file",
            :content=>"---\n:logger: console\n:backends:\n  - yaml\n\n:hierarchy:\n  - \"node/%{::clientcert}\"\n  - \"env/%{::environment}\"\n  - \"global\"\n\n:yaml:\n  :datadir: \"/etc/puppet/hiera/%{environment}\"\n\n",
            :owner=>"root",
            :group=>"root",
            :mode=>"0644",
          }).that_notifies('Class[Apache::Service]')
        end
        it 'should lay down /etc/puppet/hiera.yaml' do
          should contain_file('/etc/puppet/hiera.yaml').with({
            :path=>"/etc/puppet/hiera.yaml",
            :ensure=>"link",
            :target=>"/etc/hiera.yaml"
          }).that_requires('File[/etc/hiera.yaml]')

        end
        it 'should lay down or manage the permissions of the hieradata directory' do
          should contain_file('/etc/puppet/hiera').with({
            :path=>"/etc/puppet/hiera",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0755"
          })
        end
      end#no params

      context 'when the env_owner param has a non-standard value' do
        let(:pre_condition) {"class{'::puppet::master': env_owner => 'bogon'}"}
        it 'should adjust the ownership of the environment directory apropriately' do
          should contain_file('/etc/puppet/hiera').with({
           :path=>"/etc/puppet/hiera",
           :ensure=>"directory",
           :owner=>"bogon",
           :group=>"bogon",
           :mode=>"0755"
          })
        end
      end
      context 'when the eyaml_keys param is true' do
        let(:pre_condition) {"class{'::puppet::master': eyaml_keys => true}"}
        it 'should lay down /etc/puppet/keys' do
          should contain_file('/etc/puppet/keys').with({
            :path=>"/etc/puppet/keys",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0700"
          })
        end
        it 'should lay down /etc/puppet/keys/eyaml' do
          should contain_file('/etc/puppet/keys/eyaml').with({
            :path=>"/etc/puppet/keys/eyaml",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0700"
          })
        end
        it 'should lay down /etc/puppet/keys/eyaml/private_key.pkcs7.pem' do
          should contain_file('/etc/puppet/keys/eyaml/private_key.pkcs7.pem').with({
            :path=>"/etc/puppet/keys/eyaml/private_key.pkcs7.pem",
            :ensure=>"file",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0600",
            :source=>"puppet:///modules/local/eyaml/private_key.pkcs7.pem"
          })
        end
        it 'should lay down /etc/puppet/keys/eyaml/public_key.pkcs7.pem' do
          should contain_file('/etc/puppet/keys/eyaml/public_key.pkcs7.pem').with({
             :path=>"/etc/puppet/keys/eyaml/public_key.pkcs7.pem",
             :ensure=>"file",
             :owner=>"puppet",
             :group=>"puppet",
             :mode=>"0600",
             :source=>"puppet:///modules/local/eyaml/public_key.pkcs7.pem"
           })
        end
      end

      context 'when the hiera_backends param has a non-standard value' do
#        let(:params){default_params.merge({'hiera_backends' => {'yaml' => { 'datadir' => 'BOGON',} } })}
        let(:pre_condition) {"class{'::puppet::master': hiera_backends => {'yaml' => { datadir => 'BOGON'}}"}
        it 'should update /etc/hiera.yaml apropriately' do
          should contain_file('/etc/hiera.yaml').with({
            :path=>"/etc/hiera.yaml",
            :ensure=>"file",
            :content=>"---\n:logger: console\n:backends:\n  - yaml\n\n:hierarchy:\n  - \"node/%{::clientcert}\"\n  - \"env/%{::environment}\"\n  - \"global\"\n\n:yaml:\n  :datadir: \"BOGON\"\n\n",
            :owner=>"root",
            :group=>"root",
            :mode=>"0644"
          }).that_notifies('Class[Apache::Service]')
        end
      end

      context 'when the hieradata_path param has a non-standard value' do
        let(:pre_condition) {"class{'::puppet::master': hieradata_path => '/BOGON'}"}
        it 'should create the proper directory' do
          should contain_file('/BOGON').with({
            :path=>"/BOGON",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0755"
          })
        end
      end

      context 'when the hierarchy param has a non-standard value' do
#        let(:params){default_params.merge({'hierarchy' => ["foo", "bar", "baz"]})}
        let(:pre_condition) {"class{'::puppet::master': hierarchy => ['foo', 'bar', 'baz'] }"}
        it 'should update /etc/hiera.yaml with the specified hierarchy' do
          should contain_file('/etc/hiera.yaml').with({
            :path=>"/etc/hiera.yaml",
            :ensure=>"file",
            :content=>"---\n:logger: console\n:backends:\n  - yaml\n\n:hierarchy:\n  - \"foo\"\n  - \"bar\"\n  - \"baz\"\n\n:yaml:\n  :datadir: \"/etc/puppet/hiera/%{environment}\"\n\n",
            :owner=>"root",
            :group=>"root",
            :mode=>"0644"
          }).that_notifies('Class[Apache::Service]')
        end
      end
    end
  end
end
