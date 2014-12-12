source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.7']
end

gem 'rake'
gem 'puppet-lint', '= 1.0.1'
gem "rspec-puppet"
gem 'puppetlabs_spec_helper'
gem 'puppet', puppetversion

# Pry 0.9.9+ has some bugs on Ruby 1.8
gem 'pry', '<= 0.9.8'
