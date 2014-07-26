#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::repo', :type => :class do
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

    ['devel_repo'].each do |bools|
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

#    ['opt_hash'].each do |opt_hashes|
#      context "when the optional param #{opt_hashes} parameter has a value, but not a hash" do
#        let (:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#opt_hashes


#    ['string'].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let (:params) {{strings => false }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
#        end
#      end
#    end#strings

#    ['opt_strings'].each do |optional_strings|
#      context "when the optional parameter #{optional_strings} has a value, but it is not a string" do
#        let (:params) {{optional_strings => true }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /true is not a string./)
#        end
#      end
#    end#opt_strings

  end#input validation
  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      let (:facts) {{'osfamily' => osfam, 'operatingsystem' => 'Ubuntu', 'lsbdistid' => 'Ubuntu', 'lsbdistcodename' => 'trusty'}}
      context 'when fed no parameters' do
        it 'should add the puppetlabs apt source' do
          should contain_apt__source('puppetlabs').with({
           :name=>"puppetlabs",
           :location=>"http://apt.puppetlabs.com",
           :repos=>"main dependencies",
           :key=>"4BD6EC30",
           :key_server=>"pgp.mit.edu",
           :comment=>"puppetlabs",
           :ensure=>"present",
           :release=>"UNDEF",
           :include_src=>true,
           :required_packages=>false,
           :pin=>false
          })
        end
        it 'should remove the puppetlabs_devel apt source' do
          should contain_apt__source('puppetlabs_devel').with({
            :name=>"puppetlabs_devel",
            :ensure=>"absent",
            :location=>"http://apt.puppetlabs.com",
            :repos=>"devel",
            :key=>"4BD6EC30",
            :key_server=>"pgp.mit.edu",
            :comment=>"puppetlabs_devel",
            :release=>"UNDEF",
            :include_src=>true,
            :required_packages=>false,
            :pin=>false
          })
        end
      end#no params

      context 'when devel_repo is true' do
        let (:params){{'devel_repo' => true}}
        it 'should add the puppetlabs_devel apt source' do
          should contain_apt__source('puppetlabs_devel').with({
            :name=>"puppetlabs_devel",
            :ensure=>"present",
            :location=>"http://apt.puppetlabs.com",
            :repos=>"devel",
            :key=>"4BD6EC30",
            :key_server=>"pgp.mit.edu",
            :comment=>"puppetlabs_devel",
            :release=>"UNDEF",
            :include_src=>true,
            :required_packages=>false,
            :pin=>false
          })
        end
      end#end devel_repo

    end
  end
end
