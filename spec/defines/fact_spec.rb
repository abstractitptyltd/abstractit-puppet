#!/usr/bin/env rspec
require 'spec_helper'

describe 'puppet::fact', :type => :define do
  context 'input validation with type value is string' do
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

  end#input validation with type value is string

  context 'input validation with type value is array' do
      let (:title) { 'my_fact'}
      let (:params) {{ 'value' => ['my_val0', 'my_val1']}}
  end#input validation with type value is array

  context 'input validation with type value is hash' do
      let (:title) { 'my_fact'}
      let (:params) {{ 'value' => {'my_key0' => 'my_val0', 'my_key1' => 'my_val1'}}}
  end#input validation with type value is hash

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
          :domain => 'domain.com',
          :puppetversion => Puppet.version
        })
      end

      if Puppet.version.to_f >= 4.0
        facterbasepath  = '/opt/puppetlabs/facter'
        facterbasepath_group = 'root'
      else
        facterbasepath  = '/etc/facter'
        facterbasepath_group = 'puppet'
      end
      context 'when fed no parameters (value is string)' do
        let (:title) { 'my_fact'}
        let (:params) {{'value' => 'my_val'}}
        it 'should lay down our fact file as expected (value is string))' do
          should contain_file("#{facterbasepath}/facts.d/my_fact.yaml").with({
            :path=>"#{facterbasepath}/facts.d/my_fact.yaml",
            :ensure=>"present",
            :owner=>"root",
            :group=>"puppet",
            :mode=>"0640"
          }).with_content(
             /# custom fact my_fact/
           ).with_content(
             /---/
           ).with_content(
             /my_fact: my_val/
           ).with_validate_cmd(
             "/usr/bin/env ruby -ryaml -e \"YAML.load_file '%'\""
           )
        end
      end
      context 'when fed no parameters (value is array)' do
        let (:title) { 'my_fact'}
        let (:params) {{'value' => ['my_val0', 'my_val1']}}
        it 'should lay down our fact file as expected (value is array))' do
          should contain_file("#{facterbasepath}/facts.d/my_fact.yaml").with({
            :path=>"#{facterbasepath}/facts.d/my_fact.yaml",
            :ensure=>"present",
            :owner=>"root",
            :group=>"puppet",
            :mode=>"0640"
          }).with_content(
            /# custom fact my_fact/
          ).with_content(
            /---/
          ).with_content(
            /my_fact:/
          ).with_content(
            /- my_val0/
          ).with_content(
            /- my_val1/
          ).with_validate_cmd(
            "/usr/bin/env ruby -ryaml -e \"YAML.load_file '%'\""
          )
        end
      end
      context 'when fed no parameters (value is hash)' do
        let (:title) { 'my_fact'}
        let (:params) {{'value' => {'my_key0' => 'my_val0', 'my_key1' => 'my_val1'}}}
        it 'should lay down our fact file as expected (value is hash))' do
          should contain_file("#{facterbasepath}/facts.d/my_fact.yaml").with({
            :path=>"#{facterbasepath}/facts.d/my_fact.yaml",
            :ensure=>"present",
            :owner=>"root",
            :group=>"#{facterbasepath_group}",
            :mode=>"0640"
          }).with_content(
             /# custom fact my_fact/
           ).with_content(
             /---/
           ).with_content(
             /my_fact:/
           ).with_content(
             /my_key0: my_val0/
           ).with_content(
             /my_key1: my_val1/
           ).with_validate_cmd(
             "/usr/bin/env ruby -ryaml -e \"YAML.load_file '%'\""
           )
        end
      end

    end
  end
end
