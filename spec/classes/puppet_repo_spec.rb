#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::repo', :type => :class do
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end

      it "should install the puppetlabs-release package" do
        should contain_package('puppetlabs-release').with({'ensure' => 'latest'})
      end#puppetlabs-release

      context "when ::puppet::collection is defined" do
        let(:pre_condition){"class{'::puppet': collection => 'BOGON'}"}
        it 'should contain the puppetlabs-release-$::puppet::collection package' do
          should contain_package('puppetlabs-release-BOGON').with({'ensure' => 'latest'})
        end
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
    end #each OS
  end #on_supported_os
end
