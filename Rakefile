# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# rubocop:disable Rake/Desc
task lint_ruby: ['lint:ruby']
task lint_scss: ['lint:scss']
task lint_erb: ['lint:erb']
# rubocop:enable Rake/Desc

task default: %i[spec js_spec lint_ruby lint_scss lint_erb]
