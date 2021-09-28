class Subject < Base
  TTAPI_CALLS_EXPIRY = 1.hour

  connection do |conn|
    conn.faraday.response(:caching, write_options: { expires_in: TTAPI_CALLS_EXPIRY }) do
      Rails.cache
    end
  end

  has_many :course_subjects
  has_many :courses, through: :course_subjects
  belongs_to :subject_area, foreign_key: :type, inverse_of: :subjects, shallow_path: true
end
