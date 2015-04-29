require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'
require 'puppet-syntax/tasks/puppet-syntax'

#PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.relative = true
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc "Populate CONTRIBUTORS file"
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

task :metadata do
  sh "bundle exec metadata-json-lint metadata.json"
end

desc "Validate manifests, templates, and ruby files in lib."
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['lib/**/*.rb'].each do |lib_file|
    sh "ruby -c #{lib_file}"
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :validate,
  :lint,
  :spec,
  :metadata,
]