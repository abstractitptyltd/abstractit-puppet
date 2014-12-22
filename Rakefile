require 'fileutils'
require 'rubygems'
require 'rake'
require 'puppet-lint/tasks/puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'

# Puppet-lint Rake Specific settings
PuppetLint.configuration.with_context = true
# should enable in the future
PuppetLint.configuration.fail_on_warnings = false
PuppetLint.configuration.send("disable_autoloader_layout")
PuppetLint.configuration.ignore_paths = [
  "spec/**/*.pp",
]

# Make sure calling 'rake' alone will run the spec tests
task :default => [:syntax]
task :default => [:lint]
task :default => [:spec]

