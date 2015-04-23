source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.7.0'
  gem 'puppet-lint'
  gem "rspec-puppet", '~> 2.1'
  gem 'rspec-puppet-facts', :require => false
  gem "puppet-syntax"
  gem 'metadata-json-lint', :require => false
  gem 'puppetlabs_spec_helper'
  gem "rspec", '< 3.2.0'
  gem 'pry', '<= 0.9.8'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  # Pry 0.9.9+ has some bugs on Ruby 1.8
  gem 'pry', '<= 0.9.8'
#  gem "beaker", :git => 'https://github.com/puppetlabs/beaker.git'
#  gem "beaker-rspec"
#  gem "puppet-blacksmith"
end
