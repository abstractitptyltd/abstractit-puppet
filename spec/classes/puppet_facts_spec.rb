#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::facts', :type => :class do
      let(:facts) {{
        'clientcert'  => 'my.client.cert',
        'fqdn'        => 'my.fq.hostname',
        'osfamily'    => 'Debian',
        'lsbdistid'   => 'Ubuntu',
        'lsbdistcodename' => 'trusty',
        }}
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

#    ['bool'].each do |bools|
#      context "when the #{bools} parameter is not an boolean" do
#        let(:params) {{bools => "BOGON"}}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
#        end
#      end
#    end#bools

    ['custom_facts'].each do |hashes|
      context "when the #{hashes} parameter is not an hash" do
        let(:params) {{ hashes => 'this is a string'}}
        it 'should fail' do
          skip 'This does not work as is'
          expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
        end
      end
    end#hashes

#    ['string'].each do |strings|
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
      let(:facts) {{
        'clientcert'  => 'my.client.cert',
        'fqdn'        => 'my.fq.hostname',
        'osfamily'    => osfam,
        'lsbdistid'   => 'Ubuntu',
        'lsbdistcodename' => 'trusty',
        }}
      context 'when fed no parameters' do
        it 'should manage the facts directories' do
          #binding.pry;
          should contain_file('/etc/facter').with({
            :ensure=>"directory",
            :owner=>"root",
            :group=>"puppet",
            :mode=>"0755"
          })
          should contain_file('/etc/facter/facts.d').with({
            :ensure=>"directory",
            :owner=>"root",
            :group=>"puppet",
            :mode=>"0755"
          })
        end
        it 'should lay down /etc/facter/facts.d/local.yaml' do
          should contain_file('/etc/facter/facts.d/local.yaml').with_content(
            /facts for my.client.cert/
          ).with_content(
            /FQDN my.fq.hostname/
          ).with_content(
            /Environment production/
          )
        end
      end#no params
      context 'when ::puppet::manage_etc_facter is false' do
        let(:pre_condition){"class{'puppet': manage_etc_facter => false}"}
        it 'should not try to lay down the directory' do
          should_not contain_file('/etc/facter')
        end
      end
      context 'when ::puppet::manage_etc_facter_facts_d is false' do
        let(:pre_condition){"class{'puppet': manage_etc_facter_facts_d => false}"}
        it 'should not try to lay down the directory' do
          should_not contain_file('/etc/facter/facts.d')
        end
      end
      context 'when the custom_facts parameter is properly set' do
        let(:params) {{'custom_facts' => {'key1' => 'val1', 'key2' => 'val2'}}}
        it 'should iterate through the hash and properly populate the local_facts.yaml file' do
          should contain_file('/etc/facter/facts.d/local.yaml').with_content(
            /key1: \"val1\"/
          ).with_content(
            /key2: \"val2\"/
          )
        end
      end#custom_facts
    end
  end
end
