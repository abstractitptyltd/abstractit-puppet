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
        },
        {
          "operatingsystem" => "Debian",
          "operatingsystemrelease" => [
            "6",
            "7"
          ]
        }
      ],
    }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
      it { is_expected.to compile.with_all_deps }
      context 'when ::puppet has default parameters' do
        let(:pre_condition){"class{'::puppet': collection => 'PC1'}"}
        it 'should contain the puppetlabs ::puppet::collection repository' do
          should contain_apt__source('puppetlabs-pc1').with({
            :name=>"puppetlabs-pc1",
            :ensure=>"present",
            :location=>"http://apt.puppetlabs.com",
            :repos=>"PC1",
            :key=>[["id", "6F6B15509CF8E59E6E469F327F438280EF8D349F"], ["server", "pgp.mit.edu"]],
          })
        end
      end#no params

      context 'when ::puppet::manage_repos is false' do
        let(:pre_condition){"class{'::puppet': manage_repos => false, collection => 'PC1'}"}
        it 'should not lay down any apt sources' do
          should_not contain_apt__source('puppetlabs-pc1')
        end
      end

    end
  end
end
