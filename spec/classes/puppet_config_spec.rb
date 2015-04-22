#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::config', :type => :class do
  let(:pre_condition){ 'class{"puppet::install":}' }
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts
      end
      context 'when fed no parameters' do
        it 'should set the puppet server properly' do
          #binding.pry;
          should contain_ini_setting('puppet client server').with({
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'agent',
            'setting'=>'server',
            'value'=>'puppet'
          })
        end
        it 'should set the puppet environment properly' do
          should contain_ini_setting('puppet client environment').with({
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'agent',
            'setting'=>'environment',
            'value'=>'production'
          })
        end
        it 'should set the puppet agent runinterval properly' do
          should contain_ini_setting('puppet client runinterval').with({
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'agent',
            'setting'=>'runinterval',
            'value'=>'30m'
          })
        end
        it 'should setup puppet.conf to support structured_facts' do
          should contain_ini_setting('puppet client structured_facts').with({
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'main',
            'setting'=>'stringify_facts',
            'value'=>true
          })
        end
      end#no params
      context 'when $::puppet::puppet_server has a non-standard value' do
        let(:pre_condition){"class{'::puppet': puppet_server => 'BOGON'}"}
        it 'should properly set the server setting in puppet.conf' do
          should contain_ini_setting('puppet client server').with({
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'agent',
            'setting'=>'server',
            'value'=>'BOGON'
        })
        end
      end# custom server
      context 'when $::puppet::environment has a non-standard value' do
        let(:pre_condition) {"class{'::puppet': environment => 'BOGON'}"}
        it 'should properly set the environment setting in puppet.conf' do
          should contain_ini_setting('puppet client environment').with({
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'agent',
            'setting'=>'environment',
            'value'=>'BOGON'
        })
        end
      end# custom environment
      context 'when $::puppet::runinterval has a non-standard value' do
        let(:pre_condition) {"class{'::puppet': runinterval => 'BOGON'}"}
        it 'should properly set the runinterval setting in puppet.conf' do
          should contain_ini_setting('puppet client runinterval').with({
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'agent',
            'setting'=>'runinterval',
            'value'=>'BOGON'
          })
        end
      end# custom runinterval
      context 'when $::puppet::structured_facts is false' do
        let(:pre_condition) {"class{'::puppet': structured_facts => false}"}
        it 'should properly set the stringify_facts setting in puppet.conf' do
          should contain_ini_setting('puppet client structured_facts').with({
            'path'=>'/etc/puppet/puppet.conf',
            'section'=>'main',
            'setting'=>'stringify_facts',
            'value'=>true
          })
        end
      end# custom structured_facts
    end
  end
end
