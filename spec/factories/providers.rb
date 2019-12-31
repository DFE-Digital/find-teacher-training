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
    accredited_body? { false }
    can_add_more_sites? { true }
    courses { [] }
    train_with_us { Faker::Lorem.sentence(word_count: 100) }
    accredited_bodies { [] }
    train_with_disability { Faker::Lorem.sentence(word_count: 100) }
    website { "https://cat.me" }
    email { "info@acme-scitt.org" }
    telephone { "020 8123 4567" }
    address1 { nil }
    address2 { nil }
    address3 { nil }
    address4 { nil }
    postcode { nil }
    latitude { nil }
    longitude { nil }
    recruitment_cycle_year { "2019" }
    last_published_at { DateTime.new(2019).utc.iso8601 }
    content_status { "Published" }
    utt_contact do
      {
        name: "utt_contact@acme-scitt.org",
        email: "utt_contact@acme-scitt.org",
        telephone: "utt_contact@acme-scitt.org",
      }
    end
    web_link_contact do
      {
        name: "web_link_contact@acme-scitt.org",
        email: "web_link_contact@acme-scitt.org",
        telephone: "web_link_contact@acme-scitt.org",
      }
    end
    finance_contact do
      {
        name: "finance_contact@acme-scitt.org",
        email: "finance_contact@acme-scitt.org",
        telephone: "finance_contact@acme-scitt.org",
      }
    end
    fraud_contact do
      {
        name: "fraud_contact@acme-scitt.org",
        email: "fraud_contact@acme-scitt.org",
        telephone: "fraud_contact@acme-scitt.org",
      }
    end
    admin_contact do
      {
        name: "admin_contact@acme-scitt.org",
        email: "admin_contact@acme-scitt.org",
        telephone: "admin_contact@acme-scitt.org",
      }
    end
    gt12_contact { "gt12_contact@acme-scitt.org" }
    application_alert_contact { "application_alert_contact@acme-scitt.org" }
    send_application_alerts { "all" }

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
    end
  end
end
