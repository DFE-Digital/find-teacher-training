# frozen_string_literal: true

desc "Run javascript lint"
task js_lint: :environment do
  system "yarn lint:js"
end
