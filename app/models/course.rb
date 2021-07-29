class Course < Base
  belongs_to :recruitment_cycle, through: :provider, param: :recruitment_cycle_year
  belongs_to :provider, param: :provider_code, shallow_path: true
  has_many :site_statuses
  has_many :sites, through: :site_statuses, source: :site
  has_many :subjects

  property :fee_international, type: :string
  property :fee_uk_eu, type: :string
  property :maths, type: :string
  property :english, type: :string
  property :science, type: :string
  property :changed_at, type: :time

  self.primary_key = :course_code

  def has_fees?
    funding_type == 'fee'
  end

  def university_based?
    provider_type == 'university'
  end

  def further_education?
    level == 'further_education' && subjects.any? { |s| s.subject_name == 'Further education' || s.subject_code = '41' }
  end

  SHOW_VISA_SPONSORSHIP_FROM = 2022
  def show_visa_sponsorship?
    recruitment_cycle_year.to_i >= SHOW_VISA_SPONSORSHIP_FROM
  end
  alias_method :show_structured_entry_requirements?, :show_visa_sponsorship?

  # Most providers require GCSE grade 4 ("C"),
  # but some require grade 5 ("strong C")
  PROVIDERS_REQUIRING_GCSE_GRADE_5 = %w[U80 I30].freeze

  def gcse_grade_required
    if PROVIDERS_REQUIRING_GCSE_GRADE_5.include?(provider_code)
      5
    else
      4
    end
  end

  def accept_gcse_equivalency?
    accept_gcse_equivalency
  end
end
