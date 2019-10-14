# frozen_string_literal: true

desc "Lint ruby code"
namespace :lint do
  task :ruby do
    puts "Linting ruby..."
    system "bundle exec rubocop app config db lib spec Gemfile --format clang -a"
  end

  task :scss do
    puts "Linting scss..."
    system "bundle exec govuk-lint-sass app/webpacker/styles"
  end
end
