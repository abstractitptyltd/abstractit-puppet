#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::install', :type => 'class' do
  let (:facts) { DEFAULT_FACTS_BY_SYMBOL }

  context 'default parameters' do
    it do
      should compile.with_all_deps
      should contain_package('r10k').with(
        'ensure' => 'installed')
      should contain_package('hiera-eyaml').with(
        'ensure' => 'installed')
      should contain_class('puppet::master::install::standard')
      should contain_class('puppet::master::rack').with(
        'require' => 'Class[Puppet::Master::Install::Standard]')
    end
  end

  context 'puppet_version => BOGON' do
    let (:params) { { :puppet_version=> 'BOGON'} }
    it do
      should compile.with_all_deps
      should contain_class('puppet::master::install::standard').with(
        'puppet_version'=>'BOGON')
    end
  end

  context 'r10k_version => BOGON' do
    let (:params) { { :r10k_version => 'BOGON'} }
    it do
      should compile.with_all_deps
      should contain_package('r10k').with(
        'ensure'=>'BOGON')
    end
  end
end
