source 'https://rubygems.org'

def location_for(place, fake_version = nil)
  if place =~ /^(git:[^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

group :test do
  gem "rspec-core",             '3.1.7',                  :require => false
  gem "rspec-puppet",           '2.3.2',                  :require => false
  gem 'puppetlabs_spec_helper', :git => 'https://github.com/puppetlabs/puppetlabs_spec_helper', :require => false
  gem 'rspec-puppet-facts',     '1.3.0',                  :require => false
  gem "puppet-syntax",                                    :require => false
  gem 'metadata-json-lint',                               :require => false
  gem 'simplecov',                                        :require => false
  gem 'json',                                             :require => false
  gem "puppet-blacksmith",                                :require => false
  gem 'pry',                    '<= 0.9.8',               :require => false
  gem 'puppet-lint',                                      :require => false
  gem 'puppet-lint-unquoted_string-check',                :require => false
  gem 'puppet-lint-empty_string-check',                   :require => false
  gem 'puppet-lint-leading_zero-check',                   :require => false
  gem 'puppet-lint-variable_contains_upcase',             :require => false
  gem 'puppet-lint-spaceship_operator_without_tag-check', :require => false
  gem 'puppet-lint-absolute_classname-check',             :require => false
  gem 'puppet-lint-undef_in_function-check',              :require => false
  gem 'puppet-lint-roles_and_profiles-check',             :require => false
  # gem "rspec-puppet", :require => false
  # gem 'ci_reporter', :require => false
end

group :development do
  gem 'travis'
  gem 'travis-lint'
#  gem "beaker", :git => 'https://github.com/puppetlabs/beaker.git'
#  gem "beaker-rspec"
end

# group :system_tests do
#   if beaker_version = ENV['BEAKER_VERSION']
#     gem 'beaker', *location_for(beaker_version)
#   end
#   if beaker_rspec_version = ENV['BEAKER_RSPEC_VERSION']
#     gem 'beaker-rspec', *location_for(beaker_rspec_version)
#   else
#     gem 'beaker-rspec',  :require => false
#   end
#   gem 'serverspec',    :require => false
#   gem 'beaker-puppet_install_helper', :require => false
# end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if hieraversion = ENV['HIERA_GEM_VERSION']
  gem 'hiera', hieraversion, :require => false
else
  gem 'hiera', :require => false
end
