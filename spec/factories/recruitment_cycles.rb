FactoryBot.define do
  factory :recruitment_cycle do
    sequence(:id)
    year { RecruitmentCycle.current_year }
    application_start_date { '2018-10-09' }

    trait :next_cycle do
      year { RecruitmentCycle.current_year + 1 }
    end

    trait :previous_cycle do
      year { RecruitmentCycle.current_year - 1 }
    end
  end
end
