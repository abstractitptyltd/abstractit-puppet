#!/usr/bin/env rspec
require 'spec_helper'

describe 'puppet::fact', :type => :define do
  context 'input validation' do
      let (:title) { 'my_fact'}
      let (:params) {{ 'value' => 'my_val'}}
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

#    ['bool'].each do |bools|
#      context "when the #{bools} parameter is not an boolean" do
#        let (:params) {{bools => "BOGON"}}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
#        end
#      end
#    end#bools

#    ['hash'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let (:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes

#    ['string'].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let (:params) {{strings => false }}
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
          :concat_basedir => '/tmp',
          :domain => 'domain.com'
        })
      end
      if facts[:puppetversion] =~ '^4'
        facterbasepath  = '/opt/puppetlabs/facter'
      else
        facterbasepath  = '/etc/facter'
      end
      context 'when fed no parameters' do
        let (:title) { 'my_fact'}
        let (:params) {{'value' => 'my_val'}}
        it 'should lay down our fact file as expected' do
          should contain_file("#{facterbasepath}/facts.d/my_fact.yaml").with({
            :path=>"#{facterbasepath}/facts.d/my_fact.yaml",
            :ensure=>"present",
            :owner=>"root",
            :group=>"puppet",
            :mode=>"0640"
          }).with_content("# custom fact my_fact\n---\nmy_fact: \"my_val\"\n")
        end
      end#no params

    end
  end
end
