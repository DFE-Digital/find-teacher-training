# frozen_string_literal: true

desc 'Lint ruby code'
namespace :lint do
  desc 'Lint ruby code'
  task ruby: :environment do
    puts 'Linting ruby...'
    system 'bundle exec rubocop app config lib spec Gemfile --format clang -a'
  end

  desc 'Lint SCSS code'
  task scss: :environment do
    puts 'Linting scss...'
    system 'bundle exec scss-lint app/webpacker/styles'
  end

  desc 'Lint ERB templates'
  task erb: :environment do
    puts 'Linting erb...'
    system 'bundle exec erblint --lint-all'
  end
end
