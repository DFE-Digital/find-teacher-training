class SubjectArea < Base
  TTAPI_CALLS_EXPIRY = 1.hour

  connection do |conn|
    conn.faraday.response(:caching, write_options: { expires_in: TTAPI_CALLS_EXPIRY }) do
      Rails.cache
    end
  end

  has_many :subjects, foreign_key: :type, inverse_of: :subject_area
  self.primary_key = :typename
end
