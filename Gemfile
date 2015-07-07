source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 4.2.0'
  gem 'puppet-lint', :git =>  'https://github.com/rodjek/puppet-lint'
  gem 'puppet-lint-unquoted_string-check', :require => false
  gem 'puppet-lint-empty_string-check', :require => false
  gem 'puppet-lint-leading_zero-check', :require => false
  gem 'puppet-lint-variable_contains_upcase', :require => false
  gem 'puppet-lint-spaceship_operator_without_tag-check', :require => false
  gem 'puppet-lint-absolute_classname-check', :require => false
  gem 'puppet-lint-undef_in_function-check', :require => false
  gem 'puppet-lint-roles_and_profiles-check', :require => false
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet'#'~> 2.1'
  gem 'rspec-puppet-facts', :git => 'https://github.com/mcanevet/rspec-puppet-facts',:require => false
  gem "puppet-syntax"
  gem 'metadata-json-lint', :require => false
  gem 'puppetlabs_spec_helper', :git => 'https://github.com/puppetlabs/puppetlabs_spec_helper'
  gem "rspec", '< 3.2.0'
  # gem 'coveralls', require: false
  gem 'pry', '<= 0.9.8'
  gem "puppet-blacksmith"
end

group :development do
  gem 'travis'
  gem 'travis-lint'
#  gem "beaker", :git => 'https://github.com/puppetlabs/beaker.git'
#  gem "beaker-rspec"
end
