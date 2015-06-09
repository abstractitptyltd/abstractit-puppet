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
      if Puppet.version.to_f >= 4.0
        confdir                   = '/etc/puppetlabs/puppet'
        codedir                   = '/etc/puppetlabs/code'
        hieraconf_dir             = '/etc/puppetlabs/code'
        basemodulepath            = "#{codedir}/modules:#{confdir}/modules"
        hiera_eyaml_key_directory = "#{codedir}/hiera_eyaml_keys"
      else
        hieraconf_dir             = '/etc'
        confdir                   = '/etc/puppet'
        codedir                   = '/etc/puppet'
        basemodulepath            = "#{confdir}/modules:/usr/share/puppet/modules"
        hiera_eyaml_key_directory = "#{codedir}/hiera_eyaml_keys"
      end

      context 'when fed no parameters' do
        if Puppet.version =~ /^4\./
          it "should lay down #{codedir}/hiera.yaml" do
            should contain_file("#{codedir}/hiera.yaml").with({
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
          it "should lay down #{codedir}/hiera.yaml" do
            should contain_file("#{codedir}/hiera.yaml").with({
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

      context 'when the hiera_backends param has a non-standard value' do
        let(:pre_condition) {"class{'puppet::master': hiera_backends => { 'yaml' => { 'datadir' => '/BOGON'} }"}
        it "should update #{codedir}/hiera.yaml apropriately" do
          skip 'This does not work as is'
          should contain_file("#{codedir}/hiera.yaml").with({
            :ensure =>'file',
            :owner  =>'root',
            :group  =>'root',
            :mode   =>'0644'
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
            /  :datadir: \"\/BOGON\"/
          )
        end
      end

      context 'when the hierarchy param has a non-standard value' do
        let(:pre_condition) {"class{'puppet::master': hiera_hierarchy => ['foo', 'bar', 'baz'] }"}
        it "should update #{codedir}/hiera.yaml with the specified hierarchy" do
          should contain_file("#{codedir}/hiera.yaml").with({
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

      context 'when manage_hiera_config is false' do
        let(:pre_condition) {"class{'::puppet::master': manage_hiera_config => false}"}
        it "should not manage #{codedir}/hiera.conf" do
          should_not contain_file("#{codedir}/hiera.yaml")
        end
      end# manage_hiera_config false

      context 'when the eyaml_keys param is true' do
        let(:pre_condition) {"class{'::puppet::master': eyaml_keys => true, hiera_eyaml_pkcs7_private_key_file => 'puppet:///modules/local/eyaml/private_key.pkcs7.pem', hiera_eyaml_pkcs7_public_key_file => 'puppet:///modules/local/eyaml/public_key.pkcs7.pem'}"}
        it "should lay down #{hiera_eyaml_key_directory}" do
          should contain_file("#{hiera_eyaml_key_directory}").with({
            :path=>"#{hiera_eyaml_key_directory}",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0700"
          })
        end
        it "should lay down #{hiera_eyaml_key_directory}/private_key.pkcs7.pem" do
          should contain_file("#{hiera_eyaml_key_directory}/private_key.pkcs7.pem").with({
            :path=>"#{hiera_eyaml_key_directory}/private_key.pkcs7.pem",
            :ensure=>"file",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0600",
            :source=>"puppet:///modules/local/eyaml/private_key.pkcs7.pem"
          })
        end
        it "should lay down #{hiera_eyaml_key_directory}/public_key.pkcs7.pem" do
          should contain_file("#{hiera_eyaml_key_directory}/public_key.pkcs7.pem").with({
             :path=>"#{hiera_eyaml_key_directory}/public_key.pkcs7.pem",
             :ensure=>"file",
             :owner=>"puppet",
             :group=>"puppet",
             :mode=>"0600",
             :source=>"puppet:///modules/local/eyaml/public_key.pkcs7.pem"
           })
        end
      end

      context 'when the eyaml_keys param is true and hiera_eyaml_key_directory has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': hiera_eyaml_key_directory => '/BOGON', eyaml_keys => true, hiera_eyaml_pkcs7_private_key_file => 'puppet:///modules/local/eyaml/private_key.pkcs7.pem', hiera_eyaml_pkcs7_public_key_file => 'puppet:///modules/local/eyaml/public_key.pkcs7.pem'}"}
        it "should lay down #{hiera_eyaml_key_directory}" do
          should contain_file("/BOGON").with({
            :path=>"/BOGON",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0700"
          })
        end
        it "should lay down hiera-eyaml private_key file" do
          should contain_file("/BOGON/private_key.pkcs7.pem").with({
            :path=>"/BOGON/private_key.pkcs7.pem",
            :ensure=>"file",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0600",
            :source=>"puppet:///modules/local/eyaml/private_key.pkcs7.pem"
          })
        end
        it "should lay down hiera-eyaml public_key file" do
          should contain_file("/BOGON/public_key.pkcs7.pem").with({
             :path=>"/BOGON/public_key.pkcs7.pem",
             :ensure=>"file",
             :owner=>"puppet",
             :group=>"puppet",
             :mode=>"0600",
             :source=>"puppet:///modules/local/eyaml/public_key.pkcs7.pem"
           })
        end
      end

      context 'when the eyaml_keys param is true and hiera_eyaml_pkcs7_private_key and hiera_eyaml_pkcs7_public_key have custom values' do
        let(:pre_condition) {"class{'::puppet::master': hiera_eyaml_pkcs7_private_key => 'BOGON_private_key.pem', hiera_eyaml_pkcs7_public_key => 'BOGON_public_key.pem', eyaml_keys => true, hiera_eyaml_pkcs7_private_key_file => 'puppet:///modules/local/eyaml/private_key.pkcs7.pem', hiera_eyaml_pkcs7_public_key_file => 'puppet:///modules/local/eyaml/public_key.pkcs7.pem'}"}
        it "should lay down #{hiera_eyaml_key_directory}" do
          should contain_file("#{hiera_eyaml_key_directory}").with({
            :path=>"#{hiera_eyaml_key_directory}",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0700"
          })
        end
        it "should lay down #{hiera_eyaml_key_directory}/BOGON_private_key.pem" do
          should contain_file("#{hiera_eyaml_key_directory}/BOGON_private_key.pem").with({
            :path=>"#{hiera_eyaml_key_directory}/BOGON_private_key.pem",
            :ensure=>"file",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0600",
            :source=>"puppet:///modules/local/eyaml/private_key.pkcs7.pem"
          })
        end
        it "should lay down #{hiera_eyaml_key_directory}/BOGON_public_key.pem" do
          should contain_file("#{hiera_eyaml_key_directory}/BOGON_public_key.pem").with({
             :path=>"#{hiera_eyaml_key_directory}/BOGON_public_key.pem",
             :ensure=>"file",
             :owner=>"puppet",
             :group=>"puppet",
             :mode=>"0600",
             :source=>"puppet:///modules/local/eyaml/public_key.pkcs7.pem"
           })
        end
      end

    end
  end
end
