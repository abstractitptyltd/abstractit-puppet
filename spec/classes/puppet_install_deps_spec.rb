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

      context 'when ::puppet::collection is not defined' do
        let(:pre_condition) {"class{'puppet': collection => 'undef'}"}

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
          let(:pre_condition) {"class{'puppet': hiera_version => 'some_version'}"}
          it 'should install the specified version if the hiera packages' do
            skip 'This does not work as is'
            should contain_package('hiera').with({:ensure => 'some_version'})
          end
        end#hiera_version

        context 'and when the ::puppet::facter_version param has a custom value' do
          let(:pre_condition) {"class{'puppet': facter_version => 'some_version'}"}
          it 'should install the specified version if the facter packages' do
            skip 'This does not work as is'
            should contain_package('facter').with({:ensure => 'some_version'})
          end
        end#facter_version

      end#end ::puppet::collection undefined

    end
  end
end
