#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::repo', :type => :class do
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
      context 'when ::puppet::manage_repo_method is set to files' do
        let(:pre_condition){"class{'::puppet': manage_repo_method => 'files', collection => 'PC1'}"}
        it 'should not install puppetlabs-release-pc1 packages' do
          should_not contain_package('puppetlabs-release-pc1')
        end
        case facts[:osfamily]
        when 'Debian'
          it 'should contain the apt subclass' do
            should contain_class('puppet::repo::apt')
          end
        when 'RedHat'
          it 'should contain the yum subclass' do
            should contain_class('puppet::repo::yum')
          end
        end #case osfamily
      end #manage_repo_method files

      context 'when ::puppet::manage_repo_method is set to packages' do
        let(:pre_condition){"class{'::puppet': manage_repo_method => 'package' }"}
        context "when ::puppet::collection is set to PC1" do
          let(:pre_condition){"class{'::puppet': manage_repo_method => 'package', collection => 'PC1'}"}
          it 'should contain the puppetlabs-release-pc1 package' do
            should contain_package('puppetlabs-release-pc1')
          end
        end
      end #manage_repo_method packages

      context 'when ::puppet::manage_repos is set to false' do
        let(:pre_condition){"class{'::puppet': manage_repos => false, collection => 'PC1' }"}
        it 'should not install puppetlabs-release packages' do
          should_not contain_package('puppetlabs-release-pc1')
        end
        it 'should not contain repo classes' do
          should_not contain_class('puppet::repo::yum')
          should_not contain_class('puppet::repo::apt')
        end
      end #manage_repo_method files

    end #each OS
  end #on_supported_os
end
