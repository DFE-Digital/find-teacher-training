class Provider < Base
  belongs_to :recruitment_cycle, param: :recruitment_cycle_year
  has_many :courses, param: :course_code

  def can_sponsor_all_visas?
    can_sponsor_student_visa && can_sponsor_skilled_worker_visa
  end

  def can_only_sponsor_student_visa?
    can_sponsor_student_visa && !can_sponsor_skilled_worker_visa
  end

  def can_only_sponsor_skilled_worker_visa?
    !can_sponsor_student_visa && can_sponsor_skilled_worker_visa
  end
end
