module ResultFilters
  class LocationFilterForm
    NO_OPTION = nil
    LOCATION_OPTION = "1".freeze

    attr_reader :params, :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def valid?
      validate
      @errors.empty?
    end

  private

    def validate
      case selected_option
      when NO_OPTION
        @errors = ["Please choose an option"]
      when LOCATION_OPTION
        if location_query.nil?
          @errors = ["Postcode, town, or city", "Please enter a postcode, city or town in England"]
        else
          handle_location_option
        end
      end
    end

    def handle_location_option
      geocode_params = geocode_params_for(location_query)
      if geocode_params
        @params.merge!(geocode_params)
        @valid = true
      else
        @errors = ["Postcode, town or city", "We couldn't find this location, please check your input and try again"]
      end
    end

    def geocode_params_for(query)
      results = Geocoder.search(query, components: "country:UK")
      england_results = results.select { |r| r.state == "England" }.first
      if england_results
        {
            lat: england_results.latitude,
            lng: england_results.longitude,
            loc: england_results.address,
            lq: location_query,
        }
      end
    end

    def selected_option
      @params[:l]
    end

    def location_query
      @params[:lq]
    end

    def search_radius
      @params[:rad]
    end
  end
end
