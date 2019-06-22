#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::profile::agent', :type => :class do
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
      # it { is_expected.to compile.with_all_deps }
      confdir        = '/etc/puppetlabs/puppet'
      codedir        = '/etc/puppetlabs/code'
      context 'when fed no parameters' do
        it { should create_class('puppet') }
      end#no params
    end
  end
end
