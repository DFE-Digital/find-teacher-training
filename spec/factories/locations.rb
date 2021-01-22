FactoryBot.define do
  factory :location do
    transient do
      recruitment_cycle { build :recruitment_cycle }
    end

    sequence(:id, &:to_s)
    sequence(:code, &:to_s)
    name { 'Main Site' }
    street_address_1 { nil }
    street_address_2 { nil }
    city { nil }
    county { nil }
    postcode { nil }
    latitude { nil }
    longitude { nil }
    recruitment_cycle_year { Settings.current_cycle }
    location_status { nil }

    after :build do |course, evaluator|
      course.recruitment_cycle = evaluator.recruitment_cycle
    end
  end
end
