#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::config', :type => :class do
  let(:pre_condition){ 'class{"puppet::install":}' }
  # confdir = Puppet.settings[:confdir]
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
      if Puppet.version =~ /^4\./
        confdir = '/etc/puppetlabs/puppet'
        codedir = '/etc/puppetlabs/code'
      else
        confdir = '/etc/puppet'
      end
      context 'when fed no parameters' do
        it "should properly set the puppet server setting in #{confdir}/puppet.conf" do
          #binding.pry;
          should contain_ini_setting('puppet client server').with(
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'server',
            'value'=>'puppet'
          )
        end
        it "should properly set the environment setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client environment').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'environment',
            'value'=>'production'
          })
        end
        it "should set the puppet agent runinterval properly in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client runinterval').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'runinterval',
            'value'=>'30m'
          })
        end
        it "should setup puppet.conf to support structured_facts in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client structured_facts').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'stringify_facts',
            'value'=>true
          })
        end
      end#no params

      context 'when ::puppet::cfacter is true' do
        let(:pre_condition){"class{'::puppet': cfacter => true}"}
        it "should properly set the cfacter setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client cfacter').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'cfacter',
            'value'=>true
        })
        end
      end# cfacter

      context 'when ::puppet::puppet_server has a non-standard value' do
        let(:pre_condition){"class{'::puppet': puppet_server => 'BOGON'}"}
        it "should properly set the server setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client server').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'server',
            'value'=>'BOGON'
        })
        end
      end# custom server
      context 'when ::puppet::environment has a non-standard value' do
        let(:pre_condition) {"class{'::puppet': environment => 'BOGON'}"}
        it "should properly set the environment setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client environment').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'environment',
            'value'=>'BOGON'
        })
        end
      end# custom environment
      context 'when ::puppet::runinterval has a non-standard value' do
        let(:pre_condition) {"class{'::puppet': runinterval => 'BOGON'}"}
        it "should properly set the runinterval setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client runinterval').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'runinterval',
            'value'=>'BOGON'
          })
        end
      end# custom runinterval
      context 'when ::puppet::structured_facts is false' do
        let(:pre_condition) {"class{'::puppet': structured_facts => false}"}
        it "should properly set the stringify_facts setting in puppet.conf" do
          should contain_ini_setting('puppet client structured_facts').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'stringify_facts',
            'value'=>true
          })
        end
      end# custom structured_facts

      context 'when ::puppet::reports is false' do
        let(:pre_condition){"class{'::puppet': reports => false}"}
        it "should properly set the reports setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client reports').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'reports',
            'value'=>false
        })
        end
      end# reports

    end
  end
end
