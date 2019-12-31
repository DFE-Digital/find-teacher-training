FactoryBot.define do
  factory :site do
    transient do
      recruitment_cycle { build :recruitment_cycle }
    end

    sequence(:id, &:to_s)
    sequence(:code, &:to_s)
    location_name { "Main Site" }
    address1 { nil }
    address2 { nil }
    address3 { nil }
    address4 { nil }
    postcode { nil }
    latitude { nil }
    longitude { nil }
    recruitment_cycle_year { Settings.current_cycle }

    after :build do |course, evaluator|
      course.recruitment_cycle = evaluator.recruitment_cycle
    end
  end
end
