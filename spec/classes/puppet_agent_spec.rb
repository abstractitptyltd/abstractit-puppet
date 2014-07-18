#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::agent', :type => :class do
  let (:pre_condition){ 'class{"puppet::config":}' }
  context 'input validation' do

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

    ['ensure'].each do |bools|
      context "when the #{bools} parameter is not an boolean" do
        let (:params) {{bools => "BOGON"}}
        it 'should fail' do
          pending 'waiting on clarity of this params type'
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

    ['enable'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {{strings => false }}
        it 'should fail' do
          pending 'waiting on clarity of this params type'
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings

  end#input validation
  context "When on a Debian system" do
    let (:facts) {{'osfamily' => 'Debian'}}
    context 'when fed no parameters' do
      it 'should contain the puppet service with our default parameters' do
        should contain_service('puppet').with({
          :ensure=>true,
          :enable=>"running"
        }).that_requires('Class[Puppet::Config]')
      end
    end#no params
  end
end
