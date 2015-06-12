#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::config', :type => :class do
  let(:pre_condition){ 'class{"puppet::master::install":}' }
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
      if Puppet.version.to_f >= 4.0
        confdir        = '/etc/puppetlabs/puppet'
        codedir        = '/etc/puppetlabs/code'
        basemodulepath = "#{codedir}/modules:#{confdir}/modules"
        reports_dir    = "/opt/puppetlabs/server/data/reports"
      else
        confdir        = '/etc/puppet'
        codedir        = '/etc/puppet'
        basemodulepath = "#{confdir}/modules:/usr/share/puppet/modules"
        reports_dir    = "/var/lib/puppet/reports"
      end
      context "when fed no parameters" do
        it "should properly set the environmentpath in #{confdir}/puppet.conf" do
          should contain_ini_setting('Puppet environmentpath').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'environmentpath',
            'value'=>"#{codedir}/environments"
          })
        end
        it 'should properly set the basemodulepath' do
          should contain_ini_setting('Puppet basemodulepath').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'basemodulepath',
            'value'=>"#{basemodulepath}"
          })
        end
        it 'should disable autosign' do
          should contain_ini_setting('autosign').with({
            'ensure'=>'absent',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'master',
            'setting'=>'autosign',
            'value'=>true
          })
        end
        it 'should disable the future parser' do
          should contain_ini_setting('master parser').with({
            'ensure'=>'absent',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'master',
            'setting'=>'parser',
            'value'=>'future'
          })
        end
        it 'should create the \'puppet clean reports\' cronjob' do
          should contain_cron('puppet clean reports').with({
            :name=>"puppet clean reports",
            :command=>"cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f",
            :user=>"root",
            :hour=>"21",
            :minute=>"22",
            :weekday=>"0"
          })
        end
      end#no params

      context 'when report_age has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': report_age => '33'}"}
        it 'should create the \'puppet clean reports\' cronjob with custom mtime' do
          should contain_cron('puppet clean reports').with({
            :name=>"puppet clean reports",
            :command=>"cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +33 -print0 | xargs -0 -n50 /bin/rm -f",
            :user=>"root",
            :hour=>"21",
            :minute=>"22",
            :weekday=>"0"
          })
        end
      end #end custom report_age

      context 'when report_clean_hour has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': report_clean_hour => '12'}"}
        it 'should create the \'puppet clean reports\' cronjob with custom hour' do
          should contain_cron('puppet clean reports').with({
            :name=>"puppet clean reports",
            :command=>"cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f",
            :user=>"root",
            :hour=>"12",
            :minute=>"22",
            :weekday=>"0"
          })
        end
      end #end custom report_clean_hour

      context 'when report_clean_min has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': report_clean_min => '59'}"}
        it 'should create the \'puppet clean reports\' cronjob with custom minute' do
          should contain_cron('puppet clean reports').with({
            :name=>"puppet clean reports",
            :command=>"cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f",
            :user=>"root",
            :hour=>"21",
            :minute=>"59",
            :weekday=>"0"
          })
        end
      end #end custom report_clean_min

      context 'when report_clean_weekday has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': report_clean_weekday => '7'}"}
        it 'should create the \'puppet clean reports\' cronjob with custom weekday' do
          should contain_cron('puppet clean reports').with({
            :name=>"puppet clean reports",
            :command=>"cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f",
            :user=>"root",
            :hour=>"21",
            :minute=>"22",
            :weekday=>"7"
          })
        end
      end #end custom report_clean_weekday

      context 'when the $::puppet::master::environment_timeout variable has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': environment_timeout => 'BOGON'}"}
        it 'should update the environment_timeout via an ini_setting' do
          should contain_ini_setting('Puppet environment_timeout').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'environment_timeout',
            'value'=>'BOGON'
          })
        end
      end # environment_timeout

      context 'when the $::puppet::master::environmentpath variable has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': environmentpath => '/BOGON'}"}
        it 'should update the environmentpath via an ini_setting' do
          should contain_ini_setting('Puppet environmentpath').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'environmentpath',
            'value'=>'/BOGON'
          })
        end
      end # environmentpath

      context 'when the $::puppet::master::basemodulepath variable has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': basemodulepath => '/BOGON:/BOGON2'}"}
        it 'should update the basemodulepath via an ini_setting' do
          should contain_ini_setting('Puppet basemodulepath').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'basemodulepath',
            'value'=>'/BOGON:/BOGON2'
          })
        end
      end # basemodulepath

      context 'when the $::puppet::master::future_parser variable is true' do
        let(:pre_condition) {"class{'::puppet::master': future_parser => true}"}
        it 'should update the autosign param via an ini_setting' do
          should contain_ini_setting('master parser').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'master',
            'setting'=>'parser',
            'value'=>'future'
          })
        end
      end # future_parser

      context 'when the $::puppet::master::autosign variable is true' do
        context 'and the environment is production' do
          let(:pre_condition) {"class{'::puppet::master': autosign => true}"}
          let(:facts) do
            facts.merge({
              :environment => 'production'
            })
          end
          it 'should not enable autosign' do
            skip 'This does not work as is'
            should contain_ini_setting('autosign').with({
              'ensure'=>'absent',
              'path'=>"#{confdir}/puppet.conf",
              'section'=>'master',
              'setting'=>'autosign',
              'value'=>true
            })
          end
        end#autosign true in production
        context 'and the environment is not production' do
          let(:pre_condition) {"class{'::puppet::master': autosign => true}"}
          let(:facts) do
            facts.merge({
              :environment => 'testenv'
            })
          end
          it 'should enable autosign' do
            skip 'This does not work as is'
            should contain_ini_setting('autosign').with({
              'ensure'=>'present',
              'path'=>"#{confdir}/puppet.conf",
              'section'=>'master',
              'setting'=>'autosign',
              'value'=>true
            })
          end
        end#autosign true in other environemtns
      end## autosign true
    end
  end
end
