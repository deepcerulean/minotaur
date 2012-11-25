require "bundler/gem_tasks"

require 'rspec/core/rake_task'
require 'reek/rake/task'

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

RSpec::Core::RakeTask.new do |task|
  #task.pattern = Dir['[0-9][0-9][0-9]_*/spec/*_spec.rb'].sort
  #task.rspec_opts = Dir.glob("[0-9][0-9][0-9]_*").collect { |x| "-I#{x}" }
  task.rspec_opts = '-r spec_helper.rb --color -f d'
end