#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::agent', :type => :class do
  let(:pre_condition){ 'class{"puppet::config":}' }
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :fqdn => 'testy.hosty.com',
          :puppetversion => Puppet.version
        })
      end
      if Puppet.version.to_f >= 4.0
        bin_dir = '/opt/puppetlabs/bin'
      else
        bin_dir = '/usr/bin'
      end
      case facts[:osfamily]
      when 'Debian'
        sysconfigdir   = '/etc/defaults'
      when 'RedHat'
        sysconfigdir   = '/etc/sysconfig'
      end
      context "when puppet has default agent parameters" do
        let(:pre_condition){"class{'::puppet':}"}
        it 'should contain the puppet agent cronjob, in a disabled state' do
          should contain_cron('run_puppet_agent').with({
           :name=>"run_puppet_agent",
           :ensure=>"absent",
           :command=>"#{bin_dir}/puppet agent -t",
           :special=>"absent"
          })
        end
        it 'should contain the puppet service, enabled, per default parameters' do
          should contain_service('puppet').with({
            :ensure=>true,
            :enable=>true,
          }).that_requires('Class[Puppet::Config]')
        end
        case facts[:osfamily]
        when 'Debian'
          it "should set the start setting in #{sysconfigdir}/puppet to yes" do
            should contain_ini_setting('puppet sysconfig start').with({
              'ensure'=>'present',
              'path'=>"#{sysconfigdir}/puppet",
              'section'=>'',
              'setting'=>'START',
              'value'=>'yes'
          })
          end
        end
      end#no params
      context 'when $::puppet::enabled is true' do
        context 'when $::puppet::enable_mechanism is service' do
          let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'service'}"}
          it 'should contain the puppet agent cronjob, in a disabled state' do
            should contain_cron('run_puppet_agent').with({
             :name=>"run_puppet_agent",
             :ensure=>"absent",
             :command=>"#{bin_dir}/puppet agent -t",
             :special=>"absent"
            })
           end
          it 'should contain the puppet service, enabled, per default parameters' do
            should contain_service('puppet').with({
              :ensure=>true,
              :enable=>true,
            }).that_requires('Class[Puppet::Config]')
          end
          case facts[:osfamily]
          when 'Debian'
            it "should set the start setting in #{sysconfigdir}/puppet to yes" do
              should contain_ini_setting('puppet sysconfig start').with({
                'ensure'=>'present',
                'path'=>"#{sysconfigdir}/puppet",
                'section'=>'',
                'setting'=>'START',
                'value'=>'yes'
            })
            end
          end
        end
        context 'when $::puppet::enable_mechanism is cron' do
          let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'cron', }"}
          it'should contain the puppet service, in a disabled state' do
            should contain_service('puppet').with({
              :name=>"puppet",
              :ensure=>false,
              :enable=>false,
            }).that_requires('Class[Puppet::Config]')
          end
          case facts[:osfamily]
          when 'Debian'
            it "should set the start setting in #{sysconfigdir}/puppet to no" do
              should contain_ini_setting('puppet sysconfig start').with({
                'ensure'=>'present',
                'path'=>"#{sysconfigdir}/puppet",
                'section'=>'',
                'setting'=>'START',
                'value'=>'no'
            })
            end
          end
          it 'should enable the cronjob, running puppet twice an hour' do
            should contain_cron('run_puppet_agent').with({
              :ensure=>"present",
              :command=>"#{bin_dir}/puppet agent -t",
              :special=>"absent",
              :minute=>["3", 33],
              :hour=>"*"
            })
          end
          context 'when agent_cron_min has the value of two_times_an_hour' do
            let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'cron', agent_cron_min => 'two_times_an_hour'}"}
            it 'should enable the cronjob, running puppet twice an hour' do
              should contain_cron('run_puppet_agent').with({
                :ensure=>"present",
                :command=>"#{bin_dir}/puppet agent -t",
                :special=>"absent",
                :minute=>["3", 33],
                :hour=>"*"
              })
            end
            it'should contain the puppet service, in a disabled state' do
              should contain_service('puppet').with({
                :name=>"puppet",
                :ensure=>false,
                :enable=>false,
              })
            end
            case facts[:osfamily]
            when 'Debian'
              it "should set the start setting in #{sysconfigdir}/puppet to no" do
                should contain_ini_setting('puppet sysconfig start').with({
                  'ensure'=>'present',
                  'path'=>"#{sysconfigdir}/puppet",
                  'section'=>'',
                  'setting'=>'START',
                  'value'=>'no'
              })
              end
            end
          end
          context 'when agent_cron_min has the value of four_times_an_hour' do
            let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'cron', agent_cron_min => 'four_times_an_hour'}"}
            it 'should enable the cronjob, running puppet four times an hour' do
              should contain_cron('run_puppet_agent').with({
                :ensure=>"present",
                :command=>"#{bin_dir}/puppet agent -t",
                :special=>"absent",
                :minute=>["3", 18, 33, 48],
                :hour=>"*"
              })
            end
            it'should contain the puppet service, in a disabled state' do
              should contain_service('puppet').with({
                :name=>"puppet",
                :ensure=>false,
                :enable=>false,
              })
            end
            case facts[:osfamily]
            when 'Debian'
              it "should set the start setting in #{sysconfigdir}/puppet to no" do
                should contain_ini_setting('puppet sysconfig start').with({
                  'ensure'=>'present',
                  'path'=>"#{sysconfigdir}/puppet",
                  'section'=>'',
                  'setting'=>'START',
                  'value'=>'no'
              })
              end
            end
          end
          context 'when agent_cron_min has the value of \'30\'' do
            let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'cron', agent_cron_min => '30'}"}
            it 'should enable the cronjob, running puppet twice an hour' do
              should contain_cron('run_puppet_agent').with({
                :ensure=>"present",
                :command=>"#{bin_dir}/puppet agent -t",
                :special=>"absent",
                :minute=>"30",
                :hour=>"*"
              })
            end
            it'should contain the puppet service, in a disabled state' do
              should contain_service('puppet').with({
                :name=>"puppet",
                :ensure=>false,
                :enable=>false,
              })
            end
            case facts[:osfamily]
            when 'Debian'
              it "should set the start setting in #{sysconfigdir}/puppet to no" do
                should contain_ini_setting('puppet sysconfig start').with({
                  'ensure'=>'present',
                  'path'=>"#{sysconfigdir}/puppet",
                  'section'=>'',
                  'setting'=>'START',
                  'value'=>'no'
              })
              end
            end
          end
          context 'when agent_cron_hour has the value of \'20\'' do
            let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'cron', agent_cron_hour => '20'}"}
            it 'should enable the cronjob, running puppet twice an hour' do
              should contain_cron('run_puppet_agent').with({
                :ensure=>"present",
                :command=>"#{bin_dir}/puppet agent -t",
                :special=>"absent",
                :minute=>["3", 33],
                :hour=>"20"
              })
            end
            it'should contain the puppet service, in a disabled state' do
              should contain_service('puppet').with({
                :name=>"puppet",
                :ensure=>false,
                :enable=>false,
              })
            end
            case facts[:osfamily]
            when 'Debian'
              it "should set the start setting in #{sysconfigdir}/puppet to no" do
                should contain_ini_setting('puppet sysconfig start').with({
                  'ensure'=>'present',
                  'path'=>"#{sysconfigdir}/puppet",
                  'section'=>'',
                  'setting'=>'START',
                  'value'=>'no'
              })
              end
            end
          end
        end
      end
      context 'when $::puppet::enabled is false' do
        let(:pre_condition){"class{'::puppet': enabled => false}"}
        it'should contain the puppet service, in a disabled state' do
          should contain_service('puppet').with({
            :name=>"puppet",
            :ensure=>false,
            :enable=>false,
          })
        end
        case facts[:osfamily]
        when 'Debian'
          it "should set the start setting in #{sysconfigdir}/puppet to no" do
            should contain_ini_setting('puppet sysconfig start').with({
              'ensure'=>'present',
              'path'=>"#{sysconfigdir}/puppet",
              'section'=>'',
              'setting'=>'START',
              'value'=>'no'
          })
          end
        end
        it 'should contain the puppet agent cronjob, in a disabled state' do
          should contain_cron('run_puppet_agent').with({
           :name=>"run_puppet_agent",
           :ensure=>"absent",
           :command=>"#{bin_dir}/puppet agent -t",
           :special=>"absent"
          })
        end
      end# puppet::enabled
    end
  end
end
