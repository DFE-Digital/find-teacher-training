class LocationSuggestion
  include HTTParty

  base_uri Settings.google.places_api_host

  class << self
    def suggest(input)
      query = build_query(input)

      response = get("#{Settings.google.places_api_path}?#{query.to_query}")

      if response.success?
        JSON.parse(response.body)["predictions"].map { |p| p["description"] }.take(5)
      end
    end

  private

    def build_query(input)
      {
        key: Settings.google.gcp_api_key,
        language: "en",
        input: input,
        components: "country:uk",
        types: "geocode",
      }
    end
  end
end
