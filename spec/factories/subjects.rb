FactoryBot.define do
  factory :subject do
    sequence(:id, &:to_s)
    type { "subject" }
    subject_code { "00" }
    subject_name { "Primary with Mathematics" }
    bursary_amount { nil }
    scholarship { nil }
    early_career_payments { nil }

    trait :english do
      subject_name { "English" }
    end

    trait :mathematics do
      subject_name { "Mathematics" }
    end

    trait :biology do
      subject_name { "Biology" }
    end

    trait :english_with_primary do
      subject_name { "English with primary" }
    end

    trait :modern_languages do
      subject_name { "Modern Languages" }
    end

    trait :russian do
      subject_name { "Russian" }
    end

    trait :french do
      subject_name { "French" }
    end

    trait :japanese do
      subject_name { "Japanese" }
    end
  end
end
