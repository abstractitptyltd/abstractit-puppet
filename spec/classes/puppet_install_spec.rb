#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::install', :type => :class do
  let(:pre_condition){ 'class{"puppet::repo":}' }
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
  
      it 'should contain the ::puppet::install::deps class' do
        should contain_class('puppet::install::deps')
      end

      context 'when ::puppet has default paramaters' do
        context 'when ::puppet::allinone is true' do
          let(:pre_condition) {"class{'puppet': allinone => true}"}
          it 'should install puppet-agent' do
            contain_package('puppet-agent').that_requires("Class['::puppet::install::deps]")
          end
        end#end allinone true
        context 'when ::puppet::allinone false' do
          let(:pre_condition) {"class{'puppet': allinone => false}"}
          it 'should install puppet' do
            contain_package('puppet').that_requires("Class['::puppet::install::deps]")
          end
        end#end allinone false
      end#end default paramaters

      context 'when specific version is required' do
        context 'when ::puppet::allinone is true' do
          let(:pre_condition) {"class{'puppet': allinone => true}"}
          let(:pre_condition) {"class{'::puppet': agent_version=>'BOGON' }"}
          it 'should install puppet-agent' do
            contain_package('puppet-agent').with({
            :ensure=>"BOGON",
          }).that_requires("Class['::puppet::install::deps]")
          end
        end# allinone true
        context 'when ::puppet::allinone is false' do
          let(:pre_condition) {"class{'puppet': allinone => false}"}
          let(:pre_condition) {"class{'::puppet': puppet_version=>'BOGON' }"}
          it 'should install puppet' do
            contain_package('puppet').with({
            :ensure=>"BOGON",
          }).that_requires("Class['::puppet::install::deps]")
          end
        end# allinone false
      end

    end
  end#end OS
end#end puppet::install
