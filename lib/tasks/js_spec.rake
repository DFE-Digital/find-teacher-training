# frozen_string_literal: true

desc "Run javascript tests"
task js_spec: :environment do
  system "yarn test"
end
