FactoryBot.define do
  factory :recruitment_cycle do
    sequence(:id)
    year { CycleTimetable.current_year }
    application_start_date { '2018-10-09' }

    trait :next_cycle do
      year { CycleTimetable.next_year }
    end

    trait :previous_cycle do
      year { CycleTimetable.previous_year }
    end
  end
end
