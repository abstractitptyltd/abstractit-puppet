#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::install', :type => :class do
  let(:pre_condition){ 'class{"puppet::repo":}' }
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

      context 'when ::puppet has default paramaters' do
        it 'should install puppet-agent' do
          contain_package('puppet-agent')
        end
      end#end default paramaters

      context 'when specific version is required' do
        let(:pre_condition) {"class{'::puppet': agent_version=>'BOGON' }"}
        it 'should install puppet-agent' do
          contain_package('puppet-agent').with({
          :ensure=>"BOGON",
        })
        end
      end

    end
  end#end OS
end#end puppet::install
