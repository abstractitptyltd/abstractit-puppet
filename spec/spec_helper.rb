require 'rspec-puppet'
require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
end

if ENV['PARSER'] == 'future'
  RSpec.configure do |c|
    c.parser = 'future'
  end
end

# Store any environment variables away to be restored later

if ENV['PUPPET_GEM_VERSION'] =~ /^4\./
  RSpec.configure do |c|
    c.confdir = '/etc/puppetlabs/puppet'
    # c.codedir = '/etc/puppetlabs/code'
  end
else
  RSpec.configure do |c|
    c.confdir = '/etc/puppet'
  end
end
