FactoryBot.define do
  factory :provider do
    transient do
      sites { [] }
      recruitment_cycle { build :recruitment_cycle }
      include_counts { [] }
    end

    sequence(:id)
    sequence(:provider_code) { |n| "A#{n}" }
    provider_name { "ACME SCITT #{provider_code}" }

    lead_school

    can_add_more_sites? { true }
    courses { [] }
    train_with_us { Faker::Lorem.sentence(word_count: 100) }
    accredited_bodies { [] }
    train_with_disability { Faker::Lorem.sentence(word_count: 100) }
    website { 'https://cat.me' }
    email { 'info@acme-scitt.org' }
    telephone { '020 8123 4567' }
    address1 { nil }
    address2 { nil }
    address3 { nil }
    address4 { nil }
    postcode { nil }
    latitude { nil }
    longitude { nil }
    recruitment_cycle_year { '2019' }
    last_published_at { Time.zone.local(2019).utc.iso8601 }
    content_status { 'Published' }
    gt12_contact { 'gt12_contact@acme-scitt.org' }
    application_alert_contact { 'application_alert_contact@acme-scitt.org' }
    send_application_alerts { 'all' }

    after :build do |provider, evaluator|
      # Necessary gubbins necessary to make JSONAPIClient's associations work.
      provider.sites = []
      evaluator.sites.each do |site|
        provider.sites << site
      end

      provider.courses = []
      evaluator.courses.each do |course|
        provider.courses << course
      end

      provider.recruitment_cycle = evaluator.recruitment_cycle
      provider.recruitment_cycle_year = evaluator.recruitment_cycle.year

      provider.provider_type = if provider.accredited_body?
                                 %w[scitt university].sample
                               else
                                 'lead_school'
                               end
    end

    trait :lead_school do
      accredited_body? { false }
      provider_type { 'lead_school' }
    end

    trait :scitt do
      accredited_body? { true }
      provider_type { 'scitt' }
    end

    trait :university do
      accredited_body? { true }
      provider_type { 'university' }
    end
  end
end
