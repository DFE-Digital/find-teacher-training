FactoryBot.define do
  factory :course do
    transient do
      sites { [] }
      site_statuses { [] }
      subjects { [] }
      recruitment_cycle { build :recruitment_cycle }
    end

    sequence(:id)
    sequence(:course_code) { |n| "X10#{n}" }
    # This hardcodes the provider code to A0. This should probably be fixed at
    # some point. Right now it doesn't break anything.
    sequence(:provider_code) { 'A0' }
    name { 'English' }
    description { 'PGCE with QTS full time' }
    findable? { true }
    open_for_applications? { false }
    has_vacancies? { false }
    provider      { nil }
    study_mode    { 'full_time' }
    content_status { 'published' }
    ucas_status { 'running' }
    accrediting_provider { nil }
    qualification { 'pgce_with_qts' }
    start_date     { Time.zone.local(2019) }
    funding_type { 'fee' }
    applications_open_from { Time.zone.local(2019).utc.iso8601 }
    is_send? { false }
    level { :secondary }
    about_course { nil }
    interview_process { nil }
    how_school_placements_work { nil }
    course_length { nil }
    fee_uk_eu { nil }
    fee_details { nil }
    fee_international { nil }
    financial_support { nil }
    salary_details { nil }
    required_qualifications { nil }
    personal_qualities { nil }
    other_requirements { nil }
    last_published_at { Time.zone.local(2019).utc.iso8601 }
    has_scholarship_and_bursary? { nil }
    has_bursary? { nil }
    has_early_career_payments? { nil }
    scholarship_amount { 20_000 }
    bursary_amount { 22_000 }
    about_accrediting_body { nil }
    maths { 'expect_to_achieve_before_training_begins' }
    english { 'must_have_qualification_at_application_time' }
    science { 'not_required' }
    gcse_subjects_required { %w[maths english] }
    meta { nil }
    age_range_in_years { '11_to_16' }
    program_type { 'pg_teaching_apprenticeship' }
    changed_at { Time.zone.now }

    after :build do |course, evaluator|
      # Necessary gubbins necessary to make JSONAPIClient's associations work.
      # https://github.com/JsonApiClient/json_api_client/issues/342
      course.sites = []
      evaluator.sites.each do |site|
        course.sites << site
      end

      course.site_statuses = []
      evaluator.site_statuses.each do |site_status|
        course.site_statuses << site_status
      end

      course.subjects = []
      evaluator.subjects&.each do |subject|
        course.subjects << subject
      end

      course.recruitment_cycle = evaluator.recruitment_cycle
      course.provider_code = evaluator.provider&.provider_code
      course.provider_type = evaluator.provider&.provider_type
      course.recruitment_cycle_year = evaluator&.recruitment_cycle&.year
    end

    trait :further_education do
      level { 'further_education' }
      subjects { [build(:subject, :further_education)] }
    end

    trait :with_vacancy do
      has_vacancies? { true }
    end

    trait :with_full_time_or_part_time_vacancy do
      with_vacancy
      full_time_or_part_time
    end

    trait :with_full_time_vacancy do
      with_vacancy
      full_time
    end

    trait :with_part_time_vacancy do
      with_vacancy
      part_time
    end

    trait :full_time_or_part_time do
      study_mode { 'full_time_or_part_time' }
    end

    trait :full_time do
      study_mode { 'full_time' }
    end

    trait :part_time do
      study_mode { 'part_time' }
    end

    trait :with_fees do
      course_length { 'TwoYears' }
      fee_uk_eu { 7000 }
      fee_international { 14_000 }
      fee_details { Faker::Lorem.sentence(word_count: 100) }
      financial_support { Faker::Lorem.sentence(word_count: 100) }
    end

    trait :new do
      id                     { nil }
      qualification          { nil }
      course_code            { nil }
      name                   { nil }
      description            { nil }
      study_mode             { nil }
      content_status         { nil }
      ucas_status            { nil }
      start_date             { nil }
      funding                { nil }
      applications_open_from { nil }
      level                  { nil }
      subjects               { nil }
      last_published_at      { nil }
      scholarship_amount     { nil }
      bursary_amount         { nil }
      maths                  { nil }
      english                { nil }
      science                { nil }
      gcse_subjects_required { nil }
      age_range_in_years     { nil }
    end
  end
end
