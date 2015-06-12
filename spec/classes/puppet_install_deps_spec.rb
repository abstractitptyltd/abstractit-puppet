#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::install::deps', :type => :class do
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
        let(:pre_condition) {"class{'puppet': allinone => false}"}

        ['facter','hiera'].each do |pkg|
          context 'and when fed no parameters' do
            it "should install the #{pkg} package"do
              should contain_package(pkg).with({
                :ensure => 'installed'
              })
            end#specific package
          end#no params
        end#package iterator

        context 'and when the ::puppet::hiera_version param has a custom value' do
          let(:pre_condition) {"class{'puppet': hiera_version => 'latest'}"}
          it 'should install the specified version if the hiera packages' do
            should contain_package('hiera').with({:ensure => 'latest'})
          end
        end#hiera_version

        context 'and when the ::puppet::facter_version param has a custom value' do
          let(:pre_condition) {"class{'puppet': facter_version => 'latest'}"}
          it 'should install the specified version if the facter packages' do
            should contain_package('facter').with({:ensure => 'latest'})
          end
        end#facter_version

      end#end ::puppet::allinone undefined

    end
  end
end
