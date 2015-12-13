require "bundler/gem_tasks"
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

task :default => [ :spec, :doc, :gem]


desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
#    t.rcov = ENV['RCOV']
#    t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/}
    t.verbose = true
end


task :doc do
  system 'rm -fr doc'
  system 'rdoc -a -U'
end

task :gem do
  system 'rm guard-cunit*.gem'
  system 'gem build guard-cunit.gemspec'
end
