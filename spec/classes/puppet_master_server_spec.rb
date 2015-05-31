#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::server', :type => :class do
  let(:pre_condition){ 'class{"puppet::master":}' }
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :puppetversion => Puppet.version
        })
      end
      if Puppet.version.to_f >= 4.0
        confdir        = '/etc/puppetlabs/puppet'
        codedir        = '/etc/puppetlabs/code'
        basemodulepath = "#{codedir}/modules:/#{confdir}/modules"
      else
        confdir        = '/etc/puppet'
        codedir        = '/etc/puppet'
        basemodulepath = "#{confdir}/modules:/usr/share/puppet/modules"
      end
      case facts[:osfamily]
      when 'Debian'
        sysconfigdir   = '/etc/default'
      when 'RedHat'
        sysconfigdir   = '/etc/sysconfig'
      end
      context 'when fed no parameters' do
        it "should manage java_args in #{sysconfigdir}/puppetserver" do
          should contain_ini_subsetting('puppet server Xms java_ram').with({
            'ensure'  => 'present',
            'section' => '',
            'key_val_separator' => '=',
            'path'    => "#{sysconfigdir}/puppetserver",
            'setting'    => 'JAVA_ARGS',
            'subsetting' => '-Xms',
            'value'      => '2g',
          })
          should contain_ini_subsetting('puppet server Xmx java_ram').with({
            'ensure'  => 'present',
            'section' => '',
            'key_val_separator' => '=',
            'path'    => "#{sysconfigdir}/puppetserver",
            'setting'    => 'JAVA_ARGS',
            'subsetting' => '-Xmx',
            'value'      => '2g',
          })
        end
        it 'should manage the puppet server service' do
          should contain_service('puppetserver').with({
            'ensure'    => 'running',
            'enable'    => 'true'
          }).that_requires(
            'Class[puppet::master::config]'
          ).that_subscribes_to(
            'Class[puppet::master::config]'
          ).that_subscribes_to(
            'Class[puppet::master::hiera]'
          )
        end
      end# end no params
      context 'when puppet::master::java_ram is set' do
        let(:pre_condition) {"class{'::puppet::master': java_ram => '768m'}"}
        it "should manage java_args in #{sysconfigdir}/puppetserver" do
          should contain_ini_subsetting('puppet server Xmx java_ram').with({
            'ensure'=>'present',
            'section' => '',
            'key_val_separator' => '=',
            'path'=>"#{sysconfigdir}/puppetserver",
            'setting'=>'JAVA_ARGS',
            'subsetting' => '-Xmx',
            'value'=>"768m"
          })
          should contain_ini_subsetting('puppet server Xms java_ram').with({
            'ensure'=>'present',
            'section' => '',
            'key_val_separator' => '=',
            'path'=>"#{sysconfigdir}/puppetserver",
            'setting'=>'JAVA_ARGS',
            'subsetting' => '-Xms',
            'value'=>"768m"
          })
        end
      end# end java_ram set
    end#end OS
  end
end
