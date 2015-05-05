require 'rspec-puppet'
require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

#require 'coveralls'
#Coveralls.wear!

include RspecPuppetFacts

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  if Puppet.version.to_f >= 4.0
    c.confdir = '/etc/puppetlabs/puppet'
    # c.codedir = '/etc/puppetlabs/code'
    # Puppet.settings[:confdir] = '/etc/puppetlabs/puppet'
    # Puppet.settings[:codedir] = '/etc/puppetlabs/code'
  else
    c.confdir = '/etc/puppet'
    # Puppet.settings[:confdir] = '/etc/puppet'
  end
  if ENV['PARSER']
    Puppet.settings[:parser] = ENV['PARSER']
  end
end

at_exit { RSpec::Puppet::Coverage.report! }