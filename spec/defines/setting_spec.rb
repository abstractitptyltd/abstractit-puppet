#!/usr/bin/env rspec
require 'spec_helper'

describe 'puppet::setting', :type => :define do
  let(:pre_condition){ 'class{"puppet::defaults":}'}
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
          :domain => 'domain.com',
          :puppetversion => Puppet.version
        })
      end

      if Puppet.version.to_f >= 4.0
    	confdir = '/etc/puppetlabs/puppet'
      else
    	confdir = '/etc/puppet'
      end

      context 'when called with base options' do
        let (:title) { 'my_setting'}
        let (:params) {{ 'value' => 'my_content', 'section' => 'main'}}
        it 'should create our ini_setting as expected' do
          should contain_ini_setting('puppet main my_setting').with({
            'ensure'  =>'present',
            'path'    =>"#{confdir}/puppet.conf",
            'section' =>'main',
            'setting' =>'my_setting',
            'value'   =>'my_content'
          })
        end
      end#no params

      context 'when called with ensure set to absent' do
        let (:title) { 'my_setting'}
        let (:params) {{ 'value' => 'my_content', 'section' => 'main', 'ensure' => 'absent' }}
        it 'should create our ini_setting as expected' do
          should contain_ini_setting('puppet main my_setting').with({
            'ensure'  =>'absent',
            'path'    =>"#{confdir}/puppet.conf",
            'section' =>'main',
            'setting' =>'my_setting',
            'value'   =>'my_content'
          })
        end
      end#no params

    end
  end
end
