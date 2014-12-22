require 'rspec-puppet'
require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
end

# Load up the scenarios.yml file and create hashes both referneced by
# string as well as symbols. Default to the BY_SYMBOL hash
DEFAULT_FACTS_BY_STRING = YAML.load(File.read("scenarios.yml"))['__default_facts']
DEFAULT_FACTS_BY_SYMBOL = Hash[DEFAULT_FACTS_BY_STRING.map{|(k,v)| [k.to_sym,v]}]
