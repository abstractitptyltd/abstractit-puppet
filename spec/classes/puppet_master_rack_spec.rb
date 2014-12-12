#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::rack', :type => 'class' do
  let (:facts) { DEFAULT_FACTS_BY_SYMBOL }
  context 'default parameters' do
    it do
      should compile.with_all_deps

      should contain_file('/usr/share/puppet/rack')
      should contain_file('/usr/share/puppet/rack/puppetmasterd')
      should contain_file('/usr/share/puppet/rack/puppetmasterd/public')
      should contain_file('/usr/share/puppet/rack/puppetmasterd/tmp')
      should contain_file('/usr/share/puppet/rack/puppetmasterd/config.ru')
    end
  end
end
