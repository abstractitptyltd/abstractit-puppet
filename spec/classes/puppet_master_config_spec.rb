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
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'environmentpath',
            'value'   => "#{codedir}/environments"
          })
        end
        it 'should properly set the basemodulepath' do
          should contain_ini_setting('Puppet basemodulepath').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'basemodulepath',
            'value'   => "#{basemodulepath}"
          })
        end
        it 'should set autosign to the default' do
          should contain_ini_setting('autosign').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'autosign',
            'value'   => "#{confdir}/autosign.conf"
          })
        end
        it 'should disable the future parser' do
          should contain_ini_setting('master parser').with({
            'ensure'  => 'absent',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'parser',
            'value'   => 'future'
          })
        end
        it 'should create the \'puppet clean reports\' cronjob' do
          should contain_cron('puppet clean reports').with({
            'name'    => "puppet clean reports",
            'command' => "if test -x #{reports_dir}; then cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f; fi",
            'user'    => "root",
            'hour'    => "21",
            'minute'  => "22",
            'weekday' => "0"
          })
        end
        it 'should not set the external_nodes param via an ini_setting' do
          should contain_ini_setting('master external_nodes').with({
            'ensure'  => 'absent',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'external_nodes',
          })
        end
        it 'should not set the node_terminus param via an ini_setting' do
          should contain_ini_setting('master node_terminus').with({
            'ensure'  => 'absent',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'node_terminus',
          })
        end
      end#no params

      context 'when  $::puppet::master::autosign_method is off' do
        let(:pre_condition) {"class{'::puppet::master': autosign_method => 'off'}"}
        it 'should set autosign to false' do
          should contain_ini_setting('autosign').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'autosign',
            'value'   => false
          })
        end
      end## autosign_method off

      context 'when $::puppet::master::autosign_method is on and environment == production' do
        let(:facts) do
          facts.merge({
            :concat_basedir => '/tmp',
            :puppetversion  => Puppet.version,
            :environment    => 'production'
          })
        end
        let(:pre_condition) {"class{'::puppet::master': autosign_method => 'on'}"}
        it 'should set autosign to false' do
          skip 'This does not work as is'
          should contain_ini_setting('autosign').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'autosign',
            'value'   => false
          })
        end
      end## autosign_method on environment == production

      context 'when $::puppet::master::autosign_method is on and environment != production' do
        let(:facts) do
          facts.merge({
            :concat_basedir => '/tmp',
            :puppetversion  => Puppet.version,
            :environment    => 'development'
          })
        end
        let(:pre_condition) {"class{'::puppet::master': autosign_method => 'on'}"}
        it 'should set autosign to true' do
          should contain_ini_setting('autosign').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'autosign',
            'value'   => true
          })
        end
      end## autosign_method on environment != production

      context 'when $::puppet::master::autosign_method is file and $::puppet::master::autosign_domains is not empty' do
        let(:pre_condition) {"class{'::puppet::master': autosign_method => 'file', autosign_domains => ['*.sub1.domain.com','sub2.domain.com']}"}
        it 'should not set autosign to $confdir/autosign.conf and add autosign_domains to $confdir/autosign.conf' do
          should contain_ini_setting('autosign').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'autosign',
            'value'   => "#{confdir}/autosign.conf"
          })
          should contain_file("#{confdir}/autosign.conf").with({
            'ensure' => 'file',
            'owner'  =>'root',
            'group'  =>'root',
            'mode'   =>'0644'
          }).with_content(
            /\*.sub1.domain.com/
          ).with_content(
            /sub2.domain.com/
          )
        end
      end## autosign_method file autosign_domains not empty

      context 'when $::puppet::master::autosign_method is file and $::puppet::master::autosign_file has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': autosign_method => 'file', autosign_file => '/etc/foo/bar.conf', autosign_domains => ['*.sub1.domain.com','sub2.domain.com']}"}
        it 'should set autosign to /etc/foo/bar.conf and add autosign_domains to /etc/foo/bar.conf' do
          should contain_ini_setting('autosign').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'autosign',
            'value'   => "/etc/foo/bar.conf"
          })
          should contain_file("/etc/foo/bar.conf").with({
            'ensure' => 'file',
            'owner'  =>'root',
            'group'  =>'root',
            'mode'   =>'0644'
          }).with_content(
            /\*.sub1.domain.com/
          ).with_content(
            /sub2.domain.com/
          )
        end
      end## autosign_method file autosign_domains not empty custom autosign_file

      context 'when ::puppet::ca_server is set and this is not the ca_server' do
        let(:pre_condition){"class{'::puppet': ca_server => 'bogon.domain.com'}"}
        let(:facts) do
          facts.merge({
            :concat_basedir => '/tmp',
            :fqdn => 'notbogon.domain.com',
            :puppetversion => Puppet.version
          })
        end
        it 'should set ca to false' do
          should contain_ini_setting('puppet CA').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'ca',
            'value'   => false
          })
        end
      end# end not ca_server

      context 'when ::puppet::ca_server is set and this is the ca_server' do
        let(:pre_condition){"class{'::puppet': ca_server => 'bogon.domain.com'}"}
        let(:facts) do
          facts.merge({
            :concat_basedir => '/tmp',
            :fqdn           => 'bogon.domain.com',
            :puppetversion  => Puppet.version
          })
        end
        it 'should set ca to false' do
          should contain_ini_setting('puppet CA').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'ca',
            'value'   => true
          })
        end
      end# end ca_server

      context 'when report_age has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': report_age => '33'}"}
        it 'should create the \'puppet clean reports\' cronjob with custom mtime' do
          should contain_cron('puppet clean reports').with({
            :name    => "puppet clean reports",
            :command => "if test -x #{reports_dir}; then cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +33 -print0 | xargs -0 -n50 /bin/rm -f; fi",
            :user    => "root",
            :hour    => "21",
            :minute  => "22",
            :weekday => "0"
          })
        end
      end #end custom report_age

      context 'when report_clean_hour has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': report_clean_hour => '12'}"}
        it 'should create the \'puppet clean reports\' cronjob with custom hour' do
          should contain_cron('puppet clean reports').with({
            :name    => "puppet clean reports",
            :command => "if test -x #{reports_dir}; then cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f; fi",
            :user    => "root",
            :hour    => "12",
            :minute  => "22",
            :weekday => "0"
          })
        end
      end #end custom report_clean_hour

      context 'when report_clean_min has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': report_clean_min => '59'}"}
        it 'should create the \'puppet clean reports\' cronjob with custom minute' do
          should contain_cron('puppet clean reports').with({
            :name    => "puppet clean reports",
            :command => "if test -x #{reports_dir}; then cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f; fi",
            :user    => "root",
            :hour    => "21",
            :minute  => "59",
            :weekday => "0"
          })
        end
      end #end custom report_clean_min

      context 'when report_clean_weekday has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': report_clean_weekday => '7'}"}
        it 'should create the \'puppet clean reports\' cronjob with custom weekday' do
          should contain_cron('puppet clean reports').with({
            :name    => "puppet clean reports",
            :command => "if test -x #{reports_dir}; then cd #{reports_dir} && find . -type f -name \\*.yaml -mtime +7 -print0 | xargs -0 -n50 /bin/rm -f; fi",
            :user    => "root",
            :hour    => "21",
            :minute  => "22",
            :weekday => "7"
          })
        end
      end #end custom report_clean_weekday

      context 'when the $::puppet::master::environment_timeout variable has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': environment_timeout => 'BOGON'}"}
        it 'should update the environment_timeout via an ini_setting' do
          should contain_ini_setting('Puppet environment_timeout').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'environment_timeout',
            'value'   => 'BOGON'
          })
        end
      end # environment_timeout

      context 'when the $::puppet::master::environmentpath variable has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': environmentpath => '/BOGON'}"}
        it 'should update the environmentpath via an ini_setting' do
          should contain_ini_setting('Puppet environmentpath').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'environmentpath',
            'value'   => '/BOGON'
          })
        end
      end # environmentpath

      context 'when the $::puppet::master::basemodulepath variable has a custom value' do
        let(:pre_condition) {"class{'::puppet::master': basemodulepath => '/BOGON:/BOGON2'}"}
        it 'should update the basemodulepath via an ini_setting' do
          should contain_ini_setting('Puppet basemodulepath').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'basemodulepath',
            'value'   => '/BOGON:/BOGON2'
          })
        end
      end # basemodulepath

      context 'when the $::puppet::master::future_parser variable is true' do
        let(:pre_condition) {"class{'::puppet::master': future_parser => true}"}
        it 'should update the autosign param via an ini_setting' do
          should contain_ini_setting('master parser').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'parser',
            'value'   => 'future'
          })
        end
      end # future_parser

      context 'when the $::puppet::master::external_nodes and $::puppet::master::node_terminus variables are set' do
        let(:pre_condition) {"class{'::puppet::master': external_nodes => '/etc/puppetlabs/puppet/node.rb', node_terminus => 'exec'}"}
        it 'should update the external_nodes param via an ini_setting' do
          should contain_ini_setting('master external_nodes').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'external_nodes',
            'value'   => '/etc/puppetlabs/puppet/node.rb'
          })
        end
        it 'should update the node_terminus param via an ini_setting' do
          should contain_ini_setting('master node_terminus').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'master',
            'setting' => 'node_terminus',
            'value'   => 'exec'
          })
        end
      end # external_nodes

    end
  end
end
