#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet', :type => :class do

  context 'input validation' do
    let (:facts){{'lsbdistid' => 'Debian', 'lsbdistcodename' => 'trusty'}}

#    ['path'].each do |paths|
#      context "when the #{paths} parameter is not an absolute path" do
#        let (:params) {{ paths => 'foo' }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
#        end
#      end
#    end#absolute path

#    ['array'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let (:params) {{ arrays => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not an Array./)
#        end
#      end
#    end#arrays

    ['devel_repo','enabled','manage_etc_facter','manage_etc_facter_facts_d', 'reports','structured_facts'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let (:params) {{bools => "BOGON"}}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
        end
      end
    end#bools

#    ['hash'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let (:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes

    ['enable_mechanism'].each do |regex|
      context "when #{regex} has an unsupported value" do
        let (:params) {{regex => 'BOGON'}}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" does not match/)
        end
      end
    end#regexes


    ['environment','facter_version','hiera_version','puppet_server','puppet_version','runinterval',].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => false }}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings

  end#input validation
  context "When on a Debian system" do
    let (:facts) {{'osfamily' => 'Debian', 'lsbdistid' => 'Debian', 'lsbdistcodename' => 'trusty'}}
    context 'when fed no parameters' do
      it 'should instantiate the puppet::repo class with the default params' do
        should contain_class('puppet::repo').with({ 'devel_repo' => false})
      end
      it 'should instantiate the puppet::install class with the default params' do
        should contain_class('puppet::install').with({
          'puppet_version'=>'installed',
          'hiera_version' =>"installed",
          'facter_version'=>"installed",
          }).that_comes_before('Class[Puppet::Config]')
      end
      it 'should instantiate the puppet::config class with the default params' do
        should contain_class('puppet::config').with({
         'puppet_server'=>"puppet",
         'environment'=>"production",
         'runinterval'=>"30m",
         'structured_facts'=>false,
        }).that_notifies('class[Puppet::Agent]')
      end
      it 'should instantiate the puppet::agent class' do
        should contain_class('puppet::agent')
      end
      it 'should instantiate the puppet::facts class' do
        should contain_class('puppet::facts')
      end
    end#no params
    context 'when the devel_repo param is true' do
      let (:params){{'devel_repo' => true}}
      it 'should instantiate the puppet::repo class apropriately' do
        should contain_class('puppet::repo').with({ 'devel_repo' => true})
      end
    end#devel_repo
    context 'when the enabled param is false' do
      let (:params){{'enabled' => false}}
      it 'should instantiate the puppet::agent class' do
        should contain_class('puppet::agent')
      end
    end#enabled
    context 'when the environment param is set' do
      let (:params) {{'environment' => 'BOGON'}}
      it 'should instantiate the puppet::config class apropriately' do
        should contain_class('puppet::config').with({'environment' => 'BOGON'})
      end
    end#environment
    ['facter_version','hiera_version','puppet_version'].each do |versions|
      context "when the #{versions} param has a non-standard value" do
        let (:params) {{versions => 'BOGON'}}
        it 'should instantiate the puppet::install class apropriately' do
          should contain_class('puppet::install').with({versions => 'BOGON'})
        end
      end
    end#versions
    context 'when the puppet_server param has a non-standard value' do
      let (:params){{'puppet_server' => 'BOGON'}}
      it 'should instantiate the puppet::config class apropriately' do
        should contain_class('puppet::config').with({'puppet_server' => 'BOGON'})
      end
    end#puppet_server
    context 'when the reports param is false' do
      let (:params){{'reports' => false}}
      it 'should do something' do
        pending 'need to know what to do here'
      #binding.pry
      end
    end
    context 'when the runinterval param has a non-standard value' do
      let (:params){{'runinterval' => '60m'}}
      it 'should contain the ini_setting resourse with the proper value' do
        should contain_ini_setting('puppet client runinterval').with({
         'name'    =>"puppet client runinterval",
         'ensure'  =>"present",
         'path'    =>"/etc/puppet/puppet.conf",
         'section' =>"agent",
         'setting' =>"runinterval",
         'value'   =>"60m"
        }).that_requires('Class[Puppet::Install]')
      end
    end#runinterval
    context 'when the structured facts param has a value of true' do
      let (:params){{'structured_facts' => true}}
      it 'should instantiate the puppet::config class apropriately' do
        should contain_class('puppet::config').with({'structured_facts' => true})
      end
    end
  end#debian
end
