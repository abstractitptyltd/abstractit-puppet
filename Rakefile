require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'
require 'puppet-syntax/tasks/puppet-syntax'

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.relative = true
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
# PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
# PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

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

if RUBY_VERSION >= "2.1.0" then
  Blacksmith::RakeTask.new do |t|
    t.build = false # do not build the module nor push it to the Forge
    # just do the tagging [:clean, :tag, :bump_commit]
  end

  desc "Offload release process to Travis."
  task :travis_release => [
    :check_changelog,  # check that the changelog contains an entry for the current release
    :"module:release", # do everything except build / push to forge, travis will do that for us
  ]

  desc "Check Changelog."
  task :check_changelog do
    v = Blacksmith::Modulefile.new.version
    if File.readlines('CHANGELOG.md').grep("Releasing #{v}").size == 0 then
      fail "Unable to find a CHANGELOG.md entry for the #{v} release."
    end
  end
end
