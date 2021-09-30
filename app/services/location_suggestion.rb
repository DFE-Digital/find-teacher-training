class LocationSuggestion
  class << self
    def suggest(input)
      query = build_query(input)

      response = connection.get("#{Settings.google.places_api_path}?#{query.to_query}").body

      if response['predictions'].present?
        response['predictions']
          .map(&format_prediction)
          .take(5)
      elsif response['error_message'].present?
        Sentry.capture_message(message: response['error_message'])
      end
    end

  private

    def connection
      Faraday.new(Settings.google.places_api_host) do |f|
        f.adapter :net_http_persistent
        f.response :json
      end
    end

    def format_prediction
      lambda do |prediction|
        prediction_split = prediction['description'].split(',')
        prediction_split.first(prediction_split.size - 1).join(',')
      end
    end

    def build_query(input)
      {
        key: Settings.google.gcp_api_key,
        language: 'en',
        input: input,
        components: 'country:uk',
        types: 'geocode',
      }
    end
  end
end
