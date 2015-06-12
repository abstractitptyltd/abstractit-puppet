#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::install::deps', :type => :class do

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
      context 'when ::puppet::allinone is not defined' do
        case facts[:osfamily]
        when 'Debian'
          context 'when osfamily == Debian' do
            let(:pre_condition) {"class{'::puppet': allinone => false}"}
            it 'should install the puppetmaster-common package' do
              should contain_package('puppetmaster-common').with(
                'ensure'=>'installed',
              )
            end#end no params

            context 'when the ::puppet::master::puppet_version param has a non-standard value' do
              let(:pre_condition) {"class{'::puppet::master': puppet_version=>'latest' }"}
              it 'should install the specified version of the puppetmaster-common package' do
                # skip 'This does not work as is'
                should contain_package('puppetmaster-common').with(
                  'ensure' => 'latest',
                )
              end
            end
          end
        end
      end#end ::puppet::allinone not defined
    end
  end
end
