#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::install', :type => :class do
  # let(:pre_condition){ 'class{"puppet::repo":}' }
  on_supported_os({
    :hardwaremodels => ['x86_64'],
    :supported_os   => [
      {
        "operatingsystem" => "Ubuntu",
        "operatingsystemrelease" => [
          "12.04",
          "14.04"
        ]
      },
      {
        "operatingsystem" => "RedHat",
        "operatingsystemrelease" => [
          "5",
          "6",
          "7"
        ]
      },
      {
        "operatingsystem" => "CentOS",
        "operatingsystemrelease" => [
          "5",
          "6",
          "7"
        ]
      }
    ],
  }).each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts
      end
  
      it 'should contain the ::puppet::default::deps class' do
        should contain_class('puppet::install::deps')
      end

      context 'when ::puppet has default paramaters' do
        context 'when ::puppet::collection is defined' do
          let(:pre_condition) {"class{'puppet': collection => 'BOGON'}"}
          it 'should install puppet-agent' do
            contain_package('puppet-agent')
          end
        end#end ::puppet::collection defined
        context 'when ::puppet::collection is not defined' do
          let(:pre_condition) {"class{'puppet': collection => 'undef'}"}
          it 'should install puppet' do
            contain_package('puppet')
          end
        end#end ::puppet::collection not defined
      end#end default paramaters
    end
  end#end OS
end#end puppet::install