#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::install::standard', :type => 'class' do
  let (:facts) { DEFAULT_FACTS_BY_SYMBOL }
  context 'default parameters' do
    it do
      should compile.with_all_deps

      # Should install the puppetmaster packages
      should contain_package('puppetmaster').with(
        'ensure'=> 'installed')
      should contain_package('puppetmaster-passenger').with(
        'ensure'=> 'installed')

      # Should disable a few things that are installd by the above
      # pupppetmaster packages
      should contain_service('puppetmaster').with(
        'ensure' => 'stopped',
        'enable' => false)
      should contain_file('/etc/apache2/sites-available/puppetmaster.conf')
      should contain_file('/etc/apache2/sites-enabled/puppetmaster.conf')
    end
  end

  context 'puppet_version => BOGON' do
    let (:params) { { :puppet_version=> 'BOGON'} }

    it do
      should compile.with_all_deps
      should contain_package('puppetmaster').with(
        'ensure'=>'BOGON')
      should contain_package('puppetmaster-passenger').with(
        'ensure'=>'BOGON')
    end
  end

end
