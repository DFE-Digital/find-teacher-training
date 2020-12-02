FactoryBot.define do
  factory :site_status do
    sequence(:id)
    status { 'running' }
    has_vacancies? { nil }
    vac_status { '' }

    trait :full_time_and_part_time do
      vac_status { 'both_full_time_and_part_time_vacancies' }
      has_vacancies? { true }
    end

    trait :full_time do
      vac_status { 'full_time_vacancies' }
      has_vacancies? { true }
    end

    trait :part_time do
      vac_status { 'part_time_vacancies' }
      has_vacancies? { true }
    end

    trait :no_vacancies do
      vac_status { 'no_vacancies' }
      has_vacancies? { false }
    end
  end
end
