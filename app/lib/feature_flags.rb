class FeatureFlags
  def self.all
    [
      [:basic_auth_enabled, 'Protects requests with basic authentication', 'Apply team'],
      [:maintenance_mode, 'Puts Find into maintenance mode', 'Apply team'],
      [:maintenance_banner, 'Displays the maintenance mode banner', 'Apply team'],
      [:cache_courses, 'Caches request to the Teacher Training API for individual courses', 'Apply team'],
      [:send_web_requests_to_big_query, 'Send events to Google Big Query', 'Apply team'],
      [:bursaries_and_scholarships_announced, 'Display scholarship and bursary information', 'Apply team'],
      [:componentised_results, 'Refactors the view templates into Rails view components for the results page', 'Apply team'],
      [:new_search_flow, 'A new search flow which first asks which age you would like to teach', 'Apply team'],
    ]
  end
end
