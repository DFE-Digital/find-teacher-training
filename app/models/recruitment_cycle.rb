class RecruitmentCycle < Base
  has_many :providers
  has_many :courses, through: :providers
  has_many :sites, through: :providers

  self.primary_key = :year

  def self.current
    RecruitmentCycle.includes(:providers).find(RecruitmentCycle.current_year).first
  end

  def self.current_year
    CycleTimetable.current_year
  end

  def self.next_year
    CycleTimetable.next_year
  end

  def self.previous_year
    current_year - 1
  end
end
