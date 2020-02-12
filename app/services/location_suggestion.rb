class LocationSuggestion
  include HTTParty

  base_uri "https://maps.googleapis.com"

  class << self
    def suggest(input)
      query = build_query(input)

      response = get("/maps/api/place/autocomplete/json?#{query.to_query}")

      if response.success?
        JSON.parse(response.body)["predictions"].map { |p| p["description"] }.take(5)
      end
    end

  private

    def build_query(input)
      {
          key: Settings.gcp_api_key,
          language: "en",
          input: input,
          components: "country:uk",
          types: "geocode",
      }
    end
  end
end
