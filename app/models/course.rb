class Course < Base
  belongs_to :accrediting_provider, through: :accrediting_provider_code
  belongs_to :recruitment_cycle, through: :provider, param: :recruitment_cycle_year
  belongs_to :provider, param: :provider_code
  has_many :site_statuses
  has_many :sites, through: :site_statuses, source: :site
  has_many :subjects

  property :about_course, type: :string
  property :about_accrediting_body, type: :string
  property :applications_open_from, type: :timestamp
  property :course_code, type: :string
  property :course_length, type: :string
  property :description, type: :string
  property :english, type: :string
  property :fee_details, type: :string
  property :fee_international, type: :string
  property :fee_uk_eu, type: :string
  property :financial_support, type: :string
  property :funding_type, type: :string
  property :has_vacancies?, type: :boolean
  property :how_school_placements_work, type: :string
  property :interview_process, type: :string
  property :maths, type: :string
  property :name, type: :string
  property :other_requirements, type: :string
  property :personal_qualities, type: :string
  property :provider_code, type: :string
  property :qualification, type: :string
  property :required_qualifications, type: :string
  property :science, type: :string
  property :start_date, type: :timestamp

  self.primary_key = :course_code

  def has_fees?
    funding_type == "fee"
  end

  def year
    applications_open_from.split("-").first if applications_open_from.present?
  end

  def month
    applications_open_from.split("-").second if applications_open_from.present?
  end

  def day
    applications_open_from.split("-").third if applications_open_from.present?
  end
end
