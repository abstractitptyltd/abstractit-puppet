#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::profile::master', :type => :class do
  context 'input validation' do

    # ['path'].each do |paths|
    #   context "when the #{paths} parameter is not an absolute path" do
    #     let(:params) {{ paths => 'foo' }}
    #     it 'should fail' do
    #       skip 'This does not work as is'
    #       expect { subject }.to raise_error(Puppet::Error)#, /"foo" is not an absolute path/)
    #     end
    #   end
    # end#absolute path

    # ['array'].each do |arrays|
    #   context "when the #{arrays} parameter is not an array" do
    #     let(:params) {{ arrays => 'this is a string'}}
    #     it 'should fail' do
    #       skip 'This does not work as is'
    #        expect { subject }.to raise_error(Puppet::Error)#, /is not an Array./)
    #     end
    #   end
    # end#arrays

    # ['bool'].each do |bools|
    #   context "when the #{bools} parameter is not an boolean" do
    #     let(:params) {{bools => "BOGON"}}
    #     it 'should fail' do
    #       skip 'This does not work as is'
    #       expect { subject }.to raise_error(Puppet::Error)#, /"BOGON" is not a boolean.  It looks to be a String/)
    #     end
    #   end
    # end#bools

    # ['foo_hash'].each do |hashes|
    #   context "when the #{hashes} parameter is not an hash" do
    #     let(:params) {{ hashes => 'this is a string'}}
    #     it 'should fail' do
    #       skip 'This does not work as is'
    #        expect { subject }.to raise_error(Puppet::Error)#, /is not a Hash./)
    #     end
    #   end
    # end#hashes

    # ['string'].each do |strings|
    #   context "when the #{strings} parameter is not a string" do
    #     let(:params) {{strings => false }}
    #     it 'should fail' do
    #       skip 'This does not work as is'
    #       expect { subject }.to raise_error(Puppet::Error)#, /false is not a string./)
    #     end
    #   end
    # end#strings

  end#input validation

  on_supported_os({
      :hardwaremodels => ['x86_64'],
      :supported_os   => [
        {
          "operatingsystem" => "Ubuntu",
          "operatingsystemrelease" => [
            "14.04"
          ]
        },
        {
          "operatingsystem" => "CentOS",
          "operatingsystemrelease" => [
            "7"
          ]
        }
      ],
    }).each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
      it { is_expected.to compile.with_all_deps }
      if Puppet.version.to_f >= 4.0
        confdir        = '/etc/puppetlabs/puppet'
        codedir        = '/etc/puppetlabs/code'
      else
        confdir        = '/etc/puppet'
        codedir        = '/etc/puppet'
      end
      context 'when fed no parameters' do
      end#no params
    end
  end
end
