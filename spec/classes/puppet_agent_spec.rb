#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::agent', :type => :class do
  let(:pre_condition){ 'class{"puppet::config":}' }
  context 'input validation' do

#    ['path'].each do |paths|
#      context "when the #{paths} parameter is not an absolute path" do
#        let(:params) {{ paths => 'foo' }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
#        end
#      end
#    end#absolute path

#    ['array'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let(:params) {{ arrays => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not an Array./)
#        end
#      end
#    end#arrays

#    ['bools'].each do |bools|
#      context "when the #{bools} parameter is not an boolean" do
#        let(:params) {{bools => "BOGON"}}
#        it 'should fail' do
#          pending 'waiting on clarity of this params type'
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
#        end
#      end
#    end#bools

#    ['hash'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let(:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes

#    ['strings'].each do |strings|
#      context "when the #{strings} parameter is not a string" do
#        let(:params) {{strings => false }}
#        it 'should fail' do
#          pending 'waiting on clarity of this params type'
#          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
#        end
#      end
#    end#strings
  end#input validation
#  context "When on a Debian system" do
#    let(:facts) {{'osfamily' => 'Debian','fqdn' => 'testy.hosty.com', 'lsbdistid' => 'Debian', 'lsbdistcodename' => 'trusty'}}
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts
      end
      let:facts do
      {
        :concat_basedir => '/tmp',
        :fqdn => 'testy.hosty.com'
      }
      end
      context 'when puppet has default agent parameters' do
        let(:pre_condition){"class{'::puppet':}"}
        it 'should contain the puppet agent cronjob, in a disabled state' do
          should contain_cron('run_puppet_agent').with({
           :name=>"run_puppet_agent",
           :ensure=>"absent",
           :command=>"puppet agent -t",
           :special=>"absent"
          })
        end
        it 'should contain the puppet service, enabled, per default parameters' do
          should contain_service('puppet').with({
            :ensure=>true,
            :enable=>true,
          }).that_requires('Class[Puppet::Config]')
        end
      end#no params
      context 'when $::puppet::enabled is true' do
        context 'when $::puppet::enable_mechanism is service' do
          let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'service'}"}
          it 'should contain the puppet agent cronjob, in a disabled state' do
            should contain_cron('run_puppet_agent').with({
             :name=>"run_puppet_agent",
             :ensure=>"absent",
             :command=>"puppet agent -t",
             :special=>"absent"
            })
           end
          it 'should contain the puppet service, enabled, per default parameters' do
            should contain_service('puppet').with({
              :ensure=>true,
              :enable=>true,
            }).that_requires('Class[Puppet::Config]')
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
          it 'should enable the cronjob, running puppet twice an hour' do
            should contain_cron('run_puppet_agent').with({
              :ensure=>"present",
              :command=>"puppet agent -t",
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
                :command=>"puppet agent -t",
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
          end
          context 'when agent_cron_min has the value of four_times_an_hour' do
            let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'cron', agent_cron_min => 'four_times_an_hour'}"}
            it 'should enable the cronjob, running puppet four times an hour' do
              should contain_cron('run_puppet_agent').with({
                :ensure=>"present",
                :command=>"puppet agent -t",
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
          end
          context 'when agent_cron_min has the value of \'30\'' do
            let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'cron', agent_cron_min => '30'}"}
            it 'should enable the cronjob, running puppet twice an hour' do
              should contain_cron('run_puppet_agent').with({
                :ensure=>"present",
                :command=>"puppet agent -t",
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
          end
          context 'when agent_cron_hour has the value of \'20\'' do
            let(:pre_condition){"class{'::puppet': enabled => true, enable_mechanism => 'cron', agent_cron_hour => '20'}"}
            it 'should enable the cronjob, running puppet twice an hour' do
              should contain_cron('run_puppet_agent').with({
                :ensure=>"present",
                :command=>"puppet agent -t",
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
        it 'should contain the puppet agent cronjob, in a disabled state' do
          should contain_cron('run_puppet_agent').with({
           :name=>"run_puppet_agent",
           :ensure=>"absent",
           :command=>"puppet agent -t",
           :special=>"absent"
          })
        end
      end
    end
  end
end
