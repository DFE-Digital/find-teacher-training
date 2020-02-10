FactoryBot.define do
  factory :provider_suggestion do
    skip_create

    sequence(:id)
    sequence(:provider_code) { |n| "A#{n}" }
    provider_name { "ACME SCITT #{provider_code}" }
  end
end
