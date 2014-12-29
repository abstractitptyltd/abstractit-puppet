#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::config', :type => :class do
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

#    ['structured_facts'].each do |bools|
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

#    ['environment','puppet_server','runinterval'].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let(:params) {{strings => false }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
#        end
#      end
#    end#strings

  end#input validation

  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      let(:facts) {{'osfamily' => osfam}}
      context 'when fed no parameters' do
        it 'should set the puppet server properly' do
          #binding.pry;
          should contain_ini_setting('puppet client server').with(
            path=>'/etc/puppet/puppet.conf',
            section=>'agent',
            setting=>'server',
            value=>'puppet'
          )
        end
        it 'should set the puppet environment properly' do
          should contain_ini_setting('puppet client environment').with(
            path=>'/etc/puppet/puppet.conf',
            section=>'agent',
            setting=>'environment',
            value=>'production'
          )
        end
        it 'should set the puppet agent runinterval properly' do
          should contain_ini_setting('puppet client runinterval').with(
            path=>'/etc/puppet/puppet.conf',
            section=>'agent',
            setting=>'runinterval',
            value=>'30m'
          )
        end
        it 'should setup puppet.conf to support structured_facts' do
          should contain_ini_setting('puppet client structured_facts').with(
            path=>'/etc/puppet/puppet.conf',
            section=>'main',
            setting=>'stringify_facts',
            value=>true
          )
        end
      end#no params
      context 'when the puppet_server param has a non-standard value' do
        let(:params) {{'puppet_server' => 'BOGON'}}
        it 'should properly set the server setting in puppet.conf' do
          should contain_ini_setting('puppet client server').with(
            path=>'/etc/puppet/puppet.conf',
            section=>'agent',
            setting=>'server',
            value=>'BOGON'
          )
        end
      end# custom server
      context 'when the environment param has a non-standard value' do
        let(:params) {{'environment' => 'BOGON'}}
        it 'should properly set the environment setting in puppet.conf' do
          should contain_ini_setting('puppet client environment').with(
            path=>'/etc/puppet/puppet.conf',
            section=>'agent',
            setting=>'environment',
            value=>'BOGON'
          )
        end
      end# custom environment
      context 'when the runinterval param has a non-standard value' do
        let(:params) {{'runinterval' => 'BOGON'}}
        it 'should properly set the runinterval setting in puppet.conf' do
          should contain_ini_setting('puppet client runinterval').with(
            path=>'/etc/puppet/puppet.conf',
            section=>'agent',
            setting=>'runinterval',
            value=>'BOGON'
          )
        end
      end# custom runinterval
      context 'when the structured_facts param is false' do
        let(:params) {{'structured_facts' => false}}
        it 'should properly set the stringify_facts setting in puppet.conf' do
          should contain_ini_setting('puppet client structured_facts').with(
            path=>'/etc/puppet/puppet.conf',
            section=>'agent',
            setting=>'stringify_facts',
            value=>true
          )
        end
      end# custom structured_facts
    end
  end
end
