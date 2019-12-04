class RecruitmentCycle < Base
  has_many :providers
  has_many :courses, through: :providers
end
