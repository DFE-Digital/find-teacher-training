FactoryBot.define do
  factory :subject_area do
    type { "subject_areas" }
    id { "PrimarySubject" }
    typename { "PrimarySubject" }
    name { "Primary" }

    trait :secondary do
      id { "SecondarySubject" }
      typename { "SecondarySubject" }
      name { "Secondary" }
    end

    after(:build) do |subject_area, evaluator|
      subject_area.subjects = []
      evaluator.subjects&.each do |subject|
        subject_area.subjects << subject
      end
    end
  end
end
