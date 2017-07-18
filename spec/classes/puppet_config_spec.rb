#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::config', :type => :class do
  let(:pre_condition){ 'class{"puppet::install":}' }
  # confdir = Puppet.settings[:confdir]
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
        confdir = '/etc/puppetlabs/puppet'
        codedir = '/etc/puppetlabs/code'
      else
        confdir = '/etc/puppet'
      end
      case facts[:osfamily]
      when 'Debian'
        sysconfigdir   = '/etc/default'
      when 'RedHat'
        sysconfigdir   = '/etc/sysconfig'
      end
      context 'when fed no parameters' do
        it "should properly set the puppet server setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client server agent').with({
            'ensure'=>'absent',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'server',
            'value'=>'puppet'
          })
          should contain_ini_setting('puppet client server').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'server',
            'value'=>'puppet'
          })
        end
        it "should properly set the puppet srv records settings in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet use_srv_records').with({
            'ensure'=>'absent',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'use_srv_records',
          })
          should contain_ini_setting('puppet srv_domain').with({
            'ensure'=>'absent',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'srv_domain',
          })
        end
        it "should properly set the environment setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client environment').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'environment',
            'value'=>'production'
          })
        end
        it "should set the puppet agent runinterval properly in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client runinterval').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'runinterval',
            'value'=>'30m'
          })
        end
        it "should set the puppet agent show_diff parameter in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client show_diff').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'show_diff',
            'value'=>false
          })
        end
        it "should set the puppet agent splay parameter in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client splay').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'splay',
            'value'=>false
          })
        end
        it "should setup puppet.conf to support structured_facts in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client structured_facts').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'stringify_facts',
            'value'=>true
          })
        end
        it "should properly set the cfacter setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client cfacter').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'cfacter',
            'value'=>false
          })
        end
        it "should properly set the preferred_serialization_format setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet preferred_serialization_format').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'preferred_serialization_format',
            'value'=>'pson'
          })
        end
      end#no params

      context 'when ::puppet::ca_server is set' do
        let(:pre_condition){"class{'::puppet': ca_server => 'bogon.domain.com'}"}
        it "should set ca_server to bogon.domain.com" do
          should contain_ini_setting('puppet ca_server').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'ca_server',
            'value'   => 'bogon.domain.com'
          })
        end
      end# ca_server is set

      context 'when ::puppet::ca_server is not set' do
        let(:pre_condition){"class{'::puppet':}"}
        it "should unset ca_server" do
          should contain_ini_setting('puppet ca_server').with({
            'ensure' => 'absent',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'ca_server',
          })
        end
      end # ca_server is not set
      
      context 'when ::puppet::ca_port is set' do
        let(:pre_condition){"class{'::puppet': ca_port => '8141'}"}
        it "should set ca_port to 8141" do
          should contain_ini_setting('puppet ca_port').with({
            'ensure'  => 'present',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'ca_port',
            'value'   => '8141'
          })
        end
      end# ca_port is set

      context 'when ::puppet::ca_port is not set' do
        let(:pre_condition){"class{'::puppet':}"}
        it "should unset ca_port" do
          should contain_ini_setting('puppet ca_port').with({
            'ensure' => 'absent',
            'path'    => "#{confdir}/puppet.conf",
            'section' => 'main',
            'setting' => 'ca_port',
          })
        end
      end # ca_port is not set

      context 'when ::puppet::cfacter is true' do
        let(:pre_condition){"class{'::puppet': cfacter => true}"}
        it "should properly set the cfacter setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client cfacter').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'cfacter',
            'value'=>true
          })
        end
      end# cfacter

      context 'when ::puppet::logdest is true' do
        let(:pre_condition){"class{'::puppet': logdest => '/var/log/BOGON'}"}
        it "should properly set the logdest setting in #{sysconfigdir}/puppet" do
          should contain_ini_subsetting('puppet sysconfig logdest').with({
            'ensure'=>'present',
            'path'=>"#{sysconfigdir}/puppet",
            'section'=>'',
            'key_val_separator' => '=',
            'setting'=>'DAEMON_OPTS',
            'subsetting'=>'--logdest',
            'value'=>'/var/log/BOGON'
          })
        end
      end# logdest

      context 'when ::puppet::preferred_serialization_format is set to msgpack' do
        let(:pre_condition){"class{'::puppet': preferred_serialization_format => 'msgpack'}"}
        it "should properly set the preferred_serialization_format setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet preferred_serialization_format').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'preferred_serialization_format',
            'value'=>'msgpack'
          })
        end
      end# preferred_serialization_format

      context 'when ::puppet::puppet_server has a non-standard value' do
        let(:pre_condition){"class{'::puppet': puppet_server => 'BOGON'}"}
        it "should properly set the server setting in #{confdir}/puppet.conf" do
          should_not contain_ini_setting('puppet client server').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'server',
            'value'=>'BOGON'
          })
          should contain_ini_setting('puppet client server').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'server',
            'value'=>'BOGON'
          })
        end
      end# custom server
      context 'when ::puppet::environment has a non-standard value' do
        let(:pre_condition) {"class{'::puppet': environment => 'BOGON'}"}
        it "should properly set the environment setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client environment').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'environment',
            'value'=>'BOGON'
        })
        end
      end# custom environment
      context 'when ::puppet::runinterval has a non-standard value' do
        let(:pre_condition) {"class{'::puppet': runinterval => 'BOGON'}"}
        it "should properly set the runinterval setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client runinterval').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'runinterval',
            'value'=>'BOGON'
          })
        end
      end# custom runinterval
      context 'when ::puppet::show_diff is true' do
        let(:pre_condition) {"class{'::puppet': show_diff => true}"}
        it "should properly set the show_diff setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client show_diff').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'show_diff',
            'value'=>true
          })
        end
      end# custom show_diff
      context 'when ::puppet::splay is true' do
        let(:pre_condition) {"class{'::puppet': splay => true}"}
        it "should properly set the splay setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client splay').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'splay',
            'value'=>true
          })
        end
      end# custom splay
      context 'when ::puppet::splaylimit has a non-standard value' do
        let(:pre_condition) {"class{'::puppet': splaylimit => 'BOGON'}"}
        it "should properly set the splaylimit setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client splaylimit').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'splaylimit',
            'value'=>'BOGON'
          })
        end
      end# custom splaylimit
      context 'when ::puppet::structured_facts is false' do
        let(:pre_condition) {"class{'::puppet': structured_facts => false}"}
        it "should properly set the stringify_facts setting in puppet.conf" do
          should contain_ini_setting('puppet client structured_facts').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'stringify_facts',
            'value'=>true
          })
        end
      end# custom structured_facts

      context 'when ::puppet::reports is false' do
        let(:pre_condition){"class{'::puppet': reports => false}"}
        it "should properly set the reports setting in #{confdir}/puppet.conf" do
          should contain_ini_setting('puppet client reports').with({
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'agent',
            'setting'=>'reports',
            'value'=>false
          })
        end
      end# reports

      context 'when $::puppet::use_srv_records is true and srv_domain is foo.com' do
        let(:pre_condition){"class{'::puppet': enabled => true, use_srv_records => true, srv_domain => 'foo.com'}"}
        it'should set use_srv_records and srv_domain in puppet.conf' do
          should contain_ini_setting('puppet use_srv_records').with({
            'ensure' => 'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'use_srv_records',
            'value'=>'true',
          })
          should contain_ini_setting('puppet srv_domain').with({
            'ensure' => 'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'srv_domain',
            'value'=>'foo.com',
          })
          should contain_ini_setting('puppet client server').with({
            'ensure' => 'absent',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'server',
          })
        end
      end # puppet::use_srv_records

      context 'when $::puppet::pluginsource is set' do
        let(:pre_condition){"class{'::puppet': enabled => true, pluginsource => 'foo'}"}
        it 'should set pluginsource in puppet.conf' do
          should contain_ini_setting('puppet pluginsource').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'pluginsource',
            'value'=>'foo',
          })
        end
      end # puppet::pluginsource is set

      context 'when $::puppet::pluginsource is not set' do
        let(:pre_condition){"class{'::puppet': enabled => true}"}
        it 'should unset pluginsource in puppet.conf' do
          should contain_ini_setting('puppet pluginsource').with({
            'ensure'=>'absent',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'pluginsource',
          })
        end
      end # puppet::pluginsource is undef

      context 'when $::puppet::pluginfactsource is set' do
        let(:pre_condition){"class{'::puppet': enabled => true, pluginfactsource => 'foo'}"}
        it 'should set pluginsource in puppet.conf' do
          should contain_ini_setting('puppet pluginfactsource').with({
            'ensure'=>'present',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'pluginfactsource',
            'value'=>'foo',
          })
        end
      end # puppet::pluginfactsource is set

      context 'when $::puppet::pluginfactsource is undef' do
        let(:pre_condition){"class{'::puppet': enabled => true,}"}
        it 'should unset pluginsource in puppet.conf' do
          should contain_ini_setting('puppet pluginfactsource').with({
            'ensure'=>'absent',
            'path'=>"#{confdir}/puppet.conf",
            'section'=>'main',
            'setting'=>'pluginfactsource',
          })
        end
      end # puppet::pluginfactsource is undef

    end
  end
end
