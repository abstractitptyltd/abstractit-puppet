#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::repo::apt', :type => :class do
    on_supported_os({
      :hardwaremodels => ['x86_64'],
      :supported_os   => [
        {
          "operatingsystem" => "Ubuntu",
          "operatingsystemrelease" => [
            "12.04",
            "14.04"
          ]
        }
      ],
    }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'when ::puppet has default parameters' do
        let(:pre_condition){"class{'::puppet':}"}
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

      context 'when ::puppet::collection is defined' do
        let(:pre_condition){"class{'::puppet': collection => 'BOGON'}"}
        it 'should contain the puppetlabs ::puppet::collection repository' do
          should contain_apt__source('puppetlabs-BOGON').with({
            :name=>"puppetlabs-BOGON",
            :ensure=>"present",
            :location=>"http://apt.puppetlabs.com",
            :repos=>"BOGON",
            :key=>"4BD6EC30",
            :key_server=>"pgp.mit.edu",
            })
        end
      end

      context 'when ::puppet::manage_repos is false' do
        let(:pre_condition){"class{'::puppet': manage_repos => false}"}
        it 'should not lay down any apt sources' do
          should_not contain_apt__source('puppetlabs')
          should_not contain_apt__source('puppetlabs_devel')
        end
      end
      context 'when ::puppet::manage_repos is true' do
        context 'when ::puppet::enable_devel_repo is false' do
          let(:pre_condition){"class{'::puppet': enable_devel_repo => false}"}
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
        end

        context 'when ::puppet::enable_devel_repo is true' do
          let(:pre_condition){"class{'::puppet': enable_devel_repo => true}"}
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
end
