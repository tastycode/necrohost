require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "spec", "views"
  t.test_files = FileList["spec/**/*_spec.rb"]
end

task :spinach_env do
  ENV['RAILS_ENV'] = 'test'
end

task :spinach => :spinach_env do
  ruby '-S spinach'
end

task :all do
  Rake::Task["test"].invoke
  Rake::Task["spinach"].invoke
end
