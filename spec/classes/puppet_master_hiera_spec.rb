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
        facts.merge({
          :concat_basedir => '/tmp'
        })
      end
      let(:pre_condition){"class{'::apache':}"}
      let(:pre_condition){"class{'::puppet::master':}"}
#      let(:pre_condition){"class{'::puppet::master': hiera_backends => {'yaml' => { datadir => '/etc/puppet/hiera/%{environment}}'}"}

      context 'when fed no parameters' do
        it 'should lay down /etc/hiera.yaml' do
          should contain_file('/etc/hiera.yaml').with({
            'ensure' =>'file',
            'owner'=>'root',
            'group'=>'root',
            'mode'=>'0644',
          }).with_content(
          /:backends:/
        ).with_content(
          /- yaml/
        ).with_content(
          /:hierarchy:/
        ).with_content(
          /:datadir: \"\/etc\/puppet\/hiera\/%\{environment\}\"/
        ).that_notifies('Class[Apache::Service]')
        end
        it 'should lay down /etc/puppet/hiera.yaml' do
          should contain_file('/etc/puppet/hiera.yaml').with({
            'ensure'=>'link',
            'target'=>'/etc/hiera.yaml'
          }).that_requires('File[/etc/hiera.yaml]')

        end
        it 'should lay down or manage the permissions of the hieradata directory' do
          should contain_file('/etc/puppet/hiera').with({
            'ensure'=>"directory",
            'owner'=>"puppet",
            'group'=>"puppet",
            'mode'=>"0755"
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
        let(:pre_condition) {"class{'::puppet::master': hiera_backends => {'yaml' => { datadir => 'BOGON'}}"}
        it 'should update /etc/hiera.yaml apropriately' do
          pending 'This does not actualy work as is'
          should contain_file('/etc/hiera.yaml').with({
            'ensure'=>'file',
            'owner'=>'root',
            'group'=>'root',
            'mode'=>'0644'
          }).with_content(
            /:backends:/
          ).with_content(
            /- yaml/
          ).with_content(
            /:yaml:/
          ).with_content(
            /:datadir: \"BOGON\"/
          ).that_notifies('Class[Apache::Service]')
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
        let(:pre_condition) {"class{'::puppet::master': hierarchy => ['foo', 'bar', 'baz'] }"}
        it 'should update /etc/hiera.yaml with the specified hierarchy' do
          pending 'This does not actualy work as is'
          should contain_file('/etc/hiera.yaml').with({
            'ensure'=>'file',
            'owner'=>'root',
            'group'=>'root',
            'mode'=>'0644'
          }).with_content(
            /:hierachy:/
          ).with_content(
            /- \"foo\"/
          ).with_content(
            /- \"bar\"/
          ).with_content(
            /- \"baz\"/
          ).that_notifies('Class[Apache::Service]')
        end
      end
    end
  end
end
