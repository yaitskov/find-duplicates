require 'rake/testtask'
require 'bundler'

Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << 'test'
end


desc "Run tests"

task :default => :test
