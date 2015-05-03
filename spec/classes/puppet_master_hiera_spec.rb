#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::hiera', :type => :class do
  let(:pre_condition){ 'class{"puppet::master":}' }
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
      if Puppet.version =~ /^4\./
        hieraconf_dir  = '/opt/puppetlabs/code'
        confdir        = '/etc/puppetlabs/puppet'
        codedir        = '/etc/puppetlabs/code'
        basemodulepath = "#{codedir}/modules:/#{confdir}/modules"
      else
        hieraconf_dir  = '/etc'
        confdir        = '/etc/puppet'
        codedir        = '/etc/puppet'
        basemodulepath = "#{confdir}/modules:/usr/share/puppet/modules"
      end

      context 'when fed no parameters' do
        if Puppet.version =~ /^4\./
          it "should lay down #{hieraconf_dir}/hiera.yaml" do
            should contain_file("#{hieraconf_dir}/hiera.yaml").with({
              'ensure' =>'file',
              'owner'  =>'root',
              'group'  =>'root',
              'mode'   =>'0644'
            }).with_content(
              /:backends:/
            ).with_content(
              /  - yaml/
            ).with_content(
              /:hierarchy:/
            ).with_content(
              /  - \"node\/\%\{\:\:clientcert\}\"/
            ).with_content(
              /  - \"env\/\%\{\:\:environment\}\"/
            ).with_content(
              /  - \"global\"/
            ).with_content(
              /:yaml:/
            ).with_content(
              /  :datadir: \"\/etc\/puppetlabs\/code\/hieradata\/%\{environment\}\"/
            )
          end
        else
          it "should lay down #{hieraconf_dir}/hiera.yaml" do
            should contain_file("#{hieraconf_dir}/hiera.yaml").with({
              'ensure' =>'file',
              'owner'  =>'root',
              'group'  =>'root',
              'mode'   =>'0644'
            }).with_content(
              /:backends:/
            ).with_content(
              /  - yaml/
            ).with_content(
              /:hierarchy:/
            ).with_content(
              /  - \"node\/\%\{\:\:clientcert\}\"/
            ).with_content(
              /  - \"env\/\%\{\:\:environment\}\"/
            ).with_content(
              /  - \"global\"/
            ).with_content(
              /:yaml:/
            ).with_content(
              /  :datadir: \"\/etc\/puppet\/hieradata\/%\{environment\}\"/
            )
          end
        end

      end#no params

      context 'when the eyaml_keys param is true' do
        let(:pre_condition) {"class{'::puppet::master': eyaml_keys => true}"}
        it "should lay down /etc/puppet/keys" do
          should contain_file("/etc/puppet/keys").with({
            :path=>"/etc/puppet/keys",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0700"
          })
        end
        it "should lay down /etc/puppet/keys/eyaml" do
          should contain_file("/etc/puppet/keys/eyaml").with({
            :path=>"/etc/puppet/keys/eyaml",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0700"
          })
        end
        it "should lay down /etc/puppet/keys/eyaml/private_key.pkcs7.pem" do
          should contain_file("/etc/puppet/keys/eyaml/private_key.pkcs7.pem").with({
            :path=>"/etc/puppet/keys/eyaml/private_key.pkcs7.pem",
            :ensure=>"file",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0600",
            :source=>"puppet:///modules/local/eyaml/private_key.pkcs7.pem"
          })
        end
        it "should lay down /etc/puppet/keys/eyaml/public_key.pkcs7.pem" do
          should contain_file("/etc/puppet/keys/eyaml/public_key.pkcs7.pem").with({
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
        let(:pre_condition) {"class{'puppet::master': hiera_backends => { 'yaml' => { 'datadir' => 'BOGON'} }"}
        it "should update #{hieraconf_dir}/hiera.yaml apropriately" do
          skip 'This does not work as is'
          should contain_file("#{hieraconf_dir}/hiera.yaml").with({
            :ensure =>'file',
            :owner  =>'root',
            :group  =>'root',
            :mode   =>'0644'
          }).with_content(
            /:backends:/
          ).with_content(
            /- yaml/
          ).with_content(
            /:yaml:/
          ).with_content(
            /:datadir: \"BOGON\"/
          )
        end
      end

      # context 'when the hieradata_path param has a non-standard value' do
      #   let(:pre_condition) {"class{'puppet::master': hieradata_path => '/BOGON'}"}
      #   it 'should create the proper directory' do
      #     should contain_file('/BOGON').with({
      #       :path=>"/BOGON",
      #       :ensure=>"directory",
      #       :owner=>"puppet",
      #       :group=>"puppet",
      #       :mode=>"0755"
      #     })
      #   end
      # end

      context 'when the hierarchy param has a non-standard value' do
        let(:pre_condition) {"class{'puppet::master': hiera_hierarchy => ['foo', 'bar', 'baz'] }"}
        it "should update #{hieraconf_dir}/hiera.yaml with the specified hierarchy" do
          should contain_file("#{hieraconf_dir}/hiera.yaml").with({
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0644'
          }).with_content(
            /:hierarchy:/
          ).with_content(
            /  - \"foo\"/
          ).with_content(
            /  - \"bar\"/
          ).with_content(
            /  - \"baz\"/
          )
        end
      end
    end
  end
end
