#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet', :type => :class do

  context 'input validation' do
    let(:facts){{'lsbdistid' => 'Debian', 'lsbdistcodename' => 'trusty'}}

    ['logdest'].each do |paths|
      context "when the #{paths} parameter is not an absolute path" do
        let(:params) {{ paths => 'foo' }}
        it 'should fail' do
          skip 'This does not work as is'
            expect { should compile }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
        end
      end
    end#absolute path

#    ['array'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let(:params) {{ arrays => 'this is a string'}}
#        it 'should fail' do
#          expect {
#           should compile
#          }.to raise_error(Puppet::Error, /is not an Array/)
#        end
#      end
#    end#arrays

    ['allinone','cfacter','enable_devel_repo','enabled','enable_repo','manage_etc_facter','manage_etc_facter_facts_d','manage_repos','reports','structured_facts'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let(:params) {{bools => "BOGON"}}
        it 'should fail' do
          skip 'This does not work as is'
          expect {
           should compile
          }.to raise_error(Puppet::Error)#, /must be a boolean/)
        end
      end
    end#bools

    ['custom_facts'].each do |hashes|
      context "when the #{hashes} parameter is not an hash" do
        let(:params) {{ hashes => 'this is a string'}}
        it 'should fail' do
          skip 'This does not work as is'
          expect { 
            should compile
          }.to raise_error(Puppet::Error)
        end
      end
    end#hashes

    ['enable_mechanism'].each do |regex|
      context "when #{regex} has an unsupported value" do
        let(:params) {{regex => 'BOGON'}}
        it 'should fail' do
          skip 'This does not work as is'
          expect { 
            should compile
          }.to raise_error(Puppet::Error)
        end
      end
    end#regexes

    ['agent_version','collection','environment','facter_version','hiera_version','puppet_server','puppet_version','runinterval'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let(:params) {{strings => false }}
        it 'should fail' do
          skip 'This does not work as is'
          expect { 
            should compile
          }.to raise_error(Puppet::Error)
        end
      end
    end#strings

  end#input validation

  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :domain => 'domain.com',
          :puppetversion => Puppet.version
        })
      end
      context 'when fed no parameters' do
        it 'should instantiate the puppet::repo class with the default params' do
          should contain_class('puppet::repo')
        end
        it 'should instantiate the puppet::install class with the default params' do
          should contain_class('puppet::install').that_comes_before('Class[Puppet::Config]')
        end
        it 'should instantiate the puppet::config class with the default params' do
          should contain_class('puppet::config').that_notifies('class[Puppet::Agent]')
        end
        it 'should instantiate the puppet::agent class' do
          should contain_class('puppet::agent')
        end
      end#no params

      # context 'when the agent_version param is something other than installed' do
      #   let(:params) {{'agent_version' => 'BOGON'}}
      #   it 'should instantiate the puppet::install class apropriately' do
      #     should contain_class('puppet::install')
      #   end
      # end#agent_version

      # context 'when the allinone param is true' do
      #   let(:params){{'allinone' => true}}
      #   it 'should instantiate the puppet::install class apropriately' do
      #     should contain_class('puppet::install')
      #   end
      # end#allinone

      # context 'when the cfacter param is true' do
      #   let(:params){{'cfacter' => true}}
      #   it 'should instantiate the puppet::config class apropriately' do
      #     should contain_class('puppet::config')
      #   end
      # end#cfacter

      # context 'when the collection param is defined' do
      #   let(:params) {{'collection' => 'BOGON'}}
      #   it 'should instantiate the puppet::repo class apropriately' do
      #     should contain_class('puppet::repo')
      #   end
      # end#collection

      # context 'when the custom_facts param is set' do
      #   let(:params){{'custom_facts' => {'fact1' => 'value1','fact2' => 'value2'} }}
      #   it 'should instantiate the puppet::facts class apropriately' do
      #     should contain_class('puppet::facts').with({'custom_facts' => {'fact1' => 'value1','fact2' => 'value2'} })
      #   end
      # end#custom_facts

      # context 'when the enable_devel_repo param is true' do
      #   let(:params){{'enable_devel_repo' => true}}
      #   it 'should instantiate the puppet::repo class apropriately' do
      #     should contain_class('puppet::repo')
      #   end
      # end#enable_devel_repo

      # context 'when the enabled param is false' do
      #   let(:params){{'enabled' => false}}
      #   it 'should instantiate the puppet::agent class' do
      #     should contain_class('puppet::agent')
      #   end
      # end#enabled
      # context 'when the environment param is set' do
      #   let(:params) {{'environment' => 'BOGON'}}
      #   it 'should instantiate the puppet::config class apropriately' do
      #     should contain_class('puppet::config')
      #   end
      # end#environment
      # context 'when the logdest param is set' do
      #   let(:params) {{'logdest' => '/var/log/BOGON'}}
      #   it 'should instantiate the puppet::config class apropriately' do
      #     should contain_class('puppet::config')
      #   end
      # end#environment

      # ['facter_version','hiera_version','puppet_version'].each do |versions|
      #   context "when the #{versions} param has a non-standard value" do
      #     let(:params) {{versions => 'BOGON'}}
      #     it 'should instantiate the puppet::install class apropriately' do
      #       should contain_class('puppet::install')
      #     end
      #   end
      # end#versions
      # context 'when the puppet_server param has a non-standard value' do
      #   let(:params){{'puppet_server' => 'BOGON'}}
      #   it 'should instantiate the puppet::config class apropriately' do
      #     should contain_class('puppet::config')
      #   end
      # end#puppet_server
      # context 'when the reports param is false' do
      #   let(:params){{'reports' => false}}
      #   it 'should instantiate the puppet::config class apropriately' do
      #     should contain_class('puppet::config')
      #   end
      # end
      # context 'when the runinterval param has a non-standard value' do
      #   let(:params){{'runinterval' => 'BOGON'}}
      #   it 'should instantiate the puppet::config class apropriately' do
      #     should contain_class('puppet::config')
      #   end
      # end#runinterval
      # context 'when the structured facts param has a value of true' do
      #   let(:params){{'structured_facts' => true}}
      #   it 'should instantiate the puppet::config class apropriately' do
      #     should contain_class('puppet::config')
      #   end
      # end
    end
  end#on_supported_os
end
