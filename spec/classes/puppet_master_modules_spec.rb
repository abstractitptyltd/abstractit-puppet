#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::modules', :type => :class do
  context 'input validation' do

    ['r10k_env_basedir'].each do |paths|
      context "when the #{paths} parameter is not an absolute path" do
        let(:params) {{ paths => 'foo' }}
        it 'should fail' do
          pending 'This does not actualy work as is'
          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
        end
      end
    end#absolute path

#    ['array'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let(:params) {{ arrays => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not an Array./)
#        end
#      end
#    end#arrays

    ['r10k_purgedirs', 'r10k_update'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let(:params) {{bools => "BOGON"}}
        it 'should fail' do
          pending 'This does not actualy work as is'
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

    ['extra_env_repos'].each do |opt_hashes|
      context "when the optional param #{opt_hashes} parameter has a value, but not a hash" do
        let(:params) {{ opt_hashes => 'this is a string'}}
        it 'should fail' do
          pending 'This does not actualy work as is'
           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
        end
      end
    end#opt_hashes

    ['env_owner'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let(:params) {{strings => false }}
        it 'should fail' do
          pending 'This does not actualy work as is'
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings

    ['hiera_repo','puppet_env_repo'].each do |optional_strings|
      context "when the optional parameter #{optional_strings} has a value, but it is not a string" do
        let(:params) {{optional_strings => true }}
        it 'should fail' do
          pending 'This does not actualy work as is'
          expect { subject }.to raise_error(Puppet::Error, /true is not a string./)
        end
      end
    end

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
      let(:pre_condition) {"package{'r10k': ensure => 'present'}"}
      context 'when fed no parameters' do
        it 'should lay down /var/cache/r10k' do
          should contain_file('/var/cache/r10k').with({
            :path=>"/var/cache/r10k",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0700",
          }).that_requires('Package[r10k]')
        end
        it 'should lay down /etc/puppet/r10kenv' do
          should contain_file('/etc/puppet/r10kenv').with({
            :path=>"/etc/puppet/r10kenv",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0755"
          })
        end
        it 'should lay down /etc/r10k.yaml with the proper content' do
          should contain_file('/etc/r10k.yaml').with({
            :path=>"/etc/r10k.yaml",
            :ensure=>"file",
#            :content=>"\n\n  hiera:\n    \n    basedir: \"/etc/puppet/hiera\"\n    remote: \"\"\n\n:purgedirs:\n  - /etc/puppet/hiera\n",
            :owner=>"root",
            :group=>"root",
            :mode=>"0644",
          }).with_content(
            /:cachedir: \/var\/cache\/r10k/
          ).with_content(
            /:sources:/
          ).with_content(
            /prefix: false/
          ).that_requires('file[/var/cache/r10k]')
        end
        it 'should add the cron job to run r10k on the default schedule' do
          should contain_cron('puppet_r10k').with({
            :name=>"puppet_r10k",
            :ensure=>"present",
            :command=>"/usr/local/bin/r10k deploy environment production -p",
            :environment=>"PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin",
            :user=>"puppet",
            :minute=>["0", "15", "30", "45"]
          })
        end
      end#no params

      context 'when the env_owner param has a non-standard value' do
        let(:params) {{'env_owner' => 'BOGON'}}
        ['/var/cache/r10k','/etc/puppet/r10kenv'].each do |the_dir|
          it "should lay down #{the_dir}" do
            should contain_file(the_dir).with({
              :ensure=>"directory",
              :owner=>"BOGON",
              :group=>"BOGON",
            })
          end
        end
        it 'should add the cron job to run r10k on the default schedule' do
          should contain_cron('puppet_r10k').with({
            :name=>"puppet_r10k",
            :ensure=>"present",
            :command=>"/usr/local/bin/r10k deploy environment production -p",
            :environment=>"PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin",
            :user=>"BOGON",
            :minute=>["0", "15", "30", "45"]
          })
        end
      end
      context 'when the extra_env_repos param is populated' do
        let(:params) {{'extra_env_repos' => {'BOGON' =>{ 'repo' => 'git@bogon.site.com/bogon.git'}}}}
        it 'should lay down the properly updated /etc/r10k.yaml' do
          should contain_file('/etc/r10k.yaml').with({
            :path=>"/etc/r10k.yaml",
            :ensure=>"file",
#            :content=>"basedir: \"/etc/puppet/hiera\"\n    remote: \"\"\n  BOGON:\n    prefix: false\n    \n    remote: \"git@bogon.site.com/bogon.git\"\n\n:purgedirs:\n  - /etc/puppet/r10kenv\n  - /etc/puppet/hiera\n",
            :owner=>"root",
            :group=>"root",
            :mode=>"0644",
          }).with_content(
          /:cachedir: \/var\/cache\/r10k/
          ).with_content(
            /:sources:/
          ).with_content(
            /prefix: false/
          ).with_content(
            /remote:/
          ).with_content(
            /  BOGON:/
          ).with_content(
            /  basedir: \/etc\/puppet\/r10kenv\/BOGON/
          ).with_content(
            /  remote: \"git@bogon.site.com\/bogon.git\"/
          ).that_requires('File[/var/cache/r10k]')
        end
      end
      context 'when the hiera_repo param is populated' do
        let(:params) {{'hiera_repo' => 'BOGON'}}
          it 'should lay down the properly updated /etc/r10k.yaml' do
          should contain_file('/etc/r10k.yaml').with({
            'ensure'=>'file',
            'owner'=>'root',
            'group'=>'root',
            'mode'=>'0644',
          }).with_content(
              /basedir: \/etc\/puppet\/hiera/
            ).with_content(
              /remote: \"BOGON\"/
            ).that_requires('File[/var/cache/r10k]')
        end
      end
      context 'when the puppet_env_repo is populated' do
        let(:params) {{'puppet_env_repo' => 'BOGON'}}
          it 'should lay down the properly updated /etc/r10k.yaml' do
          should contain_file('/etc/r10k.yaml').with({
            'ensure'=>'file',
            'owner'=>'root',
            'group'=>'root',
            'mode'=>'0644',
          }).with_content(
              /puppet:/
            ).with_content(
              /basedir: \/etc\/puppet\/environments/
            ).with_content(
              /remote: \"BOGON\"/
            ).that_requires('File[/var/cache/r10k]')
        end
      end
      context 'when the r10k_env_basedir param has a non-standard value' do
        let(:params) {{'r10k_env_basedir' => '/BOGON'}}
        it 'should create the proper r10k_env_basedir' do
          should contain_file('/BOGON').with({
            :path=>"/BOGON",
            :ensure=>"directory",
            :owner=>"puppet",
            :group=>"puppet",
            :mode=>"0755"
          })
        end
      end
      context 'when the r10k_minutes param has a non-standard value' do
        let(:params) {{'r10k_minutes' => '1'}}
        it 'should add the cron job to run r10k on the default schedule' do
          should contain_cron('puppet_r10k').with({
            :name=>"puppet_r10k",
            :ensure=>"present",
            :command=>"/usr/local/bin/r10k deploy environment production -p",
            :environment=>"PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin",
            :user=>"puppet",
            :minute=>"1"
          })
        end
      end
      context 'when the r10k_purgedirs param is false' do
        let(:params) {{'r10k_purgedirs' => false}}
        it 'should update r10k.yaml apropriately' do
          should contain_file('/etc/r10k.yaml').with({
           :path=>"/etc/r10k.yaml",
           :ensure=>"file",
           :content=>":cachedir: /var/cache/r10k\n:sources:\n  hiera:\n    prefix: false\n    basedir: \"/etc/puppet/hiera\"\n    remote: \"\"\n\n",
           :owner=>"root",
           :group=>"root",
           :mode=>"0644",}).without_content(
            /:purgedirs:/
          ).that_requires('File[/var/cache/r10k]')
        end
      end
      context 'when the r10k_update param is false' do
        let(:params) {{'r10k_update' => false}}
        it 'should remove the cronjob' do
          should contain_cron('puppet_r10k').with({
            :name=>"puppet_r10k",
            :ensure=>"absent",
            :command=>"/usr/local/bin/r10k deploy environment production -p",
            :environment=>"PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin",
            :user=>"puppet",
            :minute=>["0", "15", "30", "45"]
          })
        end
      end
    end
  end
end
