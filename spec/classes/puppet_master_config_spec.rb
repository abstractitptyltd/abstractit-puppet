#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::config', :type => :class do
  context 'input validation' do

#    ['environmentpath'].each do |paths|
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

#    ['autosign','future_parser'].each do |bools|
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

#    ['extra_module_path'].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let(:params) {{strings => false }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
#        end
#      end
#    end#strings

  end#input validation

  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp'
        })
      end
      context 'when fed no parameters' do
        it 'should behave differently' do
          #binding.pry;
        end
        it 'should properly set the environmentpath' do
          should contain_ini_setting('Puppet environmentpath').with({
            'ensure'=>'present',
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'main',
            'setting'=>'environmentpath',
            'value'=>'/etc/puppet/environments'
          })
        end
        it 'should properly set the basemodulepath' do
          should contain_ini_setting('Puppet basemodulepath').with({
            'ensure'=>'present',
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'main',
            'setting'=>'basemodulepath',
            'value'=>'/etc/puppet/site:/usr/share/puppet/modules'
          })
        end
        it 'should disable autosign' do
          should contain_ini_setting('autosign').with({
            'ensure'=>'absent',
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'master',
            'setting'=>'autosign',
            'value'=>true
          })
        end
        it 'should disable the future parser' do
          should contain_ini_setting('master parser').with({
            'ensure'=>'absent',
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'master',
            'setting'=>'parser',
            'value'=>'future'
          })
        end
      end#no params

      context 'when the $::puppet::master::environmentpath variable has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': environmentpath => '/BOGON'}"}
        it 'should update the environmentpath via an ini_setting' do
          should contain_ini_setting('Puppet environmentpath').with({
            'ensure'=>'present',
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'main',
            'setting'=>'environmentpath',
            'value'=>'/BOGON'
          })
        end
      end

      context 'when the $::puppet::master::module_path variable has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': module_path => '/BOGON:/BOGON2'}"}
        it 'should update the basemodulepath via an ini_setting' do
          should contain_ini_setting('Puppet basemodulepath').with({
            'ensure'=>'present',
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'main',
            'setting'=>'basemodulepath',
            'value'=>'/BOGON:/BOGON2'
          })
        end
      end

      context 'when the $::puppet::master::future_parser variable is true' do
        let(:pre_condition) {"class{'::puppet::master': future_parser => true}"}
        it 'should update the autosign param via an ini_setting' do
          should contain_ini_setting('master parser').with({
            'ensure'=>'present',
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'master',
            'setting'=>'parser',
            'value'=>'future'
          })
        end
      end

      context 'when the $::puppet::master::autosign variable is true' do
       # let(:facts)
        let(:pre_condition) {"class{'::puppet::master': autosign => true}"}
        let(:facts)  {{ 'environment' => 'production'}}
        context 'and the environment is production' do
          it 'should not enable autosign' do
#            Puppet.settings[:environment] = 'production'
            should contain_ini_setting('autosign').with({
              'ensure'=>'absent',
              'path'=>'/etc/puppet/puppet.conf',
              'section'=>'master',
              'setting'=>'autosign',
              'value'=>true
            })
          end
        end#autosign true in production
        context 'and the environment is not production' do
          let(:pre_condition) {"class{'::puppet::master': autosign => true}"}
          let(:facts) {{'environment' => 'testenv'}}
          it 'should enable autosign' do
            should contain_ini_setting('autosign').with({
              'ensure'=>'present',
              'path'=>'/etc/puppet/puppet.conf',
              'section'=>'master',
              'setting'=>'autosign',
              'value'=>true
            })
          end
        end#autosign true in other environemtns
      end## autosign true
    end
  end
end
