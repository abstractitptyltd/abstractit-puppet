#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::profile::r10k', :type => :class do
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
            "6",
            "7"
          ]
        }
      ],
    }).each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :fqdn           => 'constructorfleet.vogon.gal',
          :domain         => 'vogon.gal',
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
        it 'should contain class r10k' do
          should contain_class('r10k').with({
            :version => 'installed'
          })
        end
        # it 'should contain puppet_r10k cron' do
        #   should contain_cron('puppet_r10k').with({
        #     :ensure      => true,
        #     :command     => "r10k deploy environment production -p",
        #     :environment => 'PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin',
        #     :user        => true,
        #     :minute      => [0,15,30,45],
        #   })
        # end
      end#no params

    end
  end
end
