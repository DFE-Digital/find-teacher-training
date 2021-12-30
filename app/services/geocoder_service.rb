class GeocoderService
  def self.location_params_for(query)
    new(query).location_params
  end

  def initialize(query)
    @query = query
  end

  def location_params
    results = Geocoder.search(query, components: 'country:UK').first
    if results
      {
        lat: results.latitude,
        lng: results.longitude,
        loc: results.address,
        lq: query,
        c: country(results),
        sortby: ResultsView::DISTANCE,
      }
    end
  end

private

  attr_reader :query

  def country(results)
    flattened_results = results.address_components.map(&:values).flatten
    countries = [DEVOLVED_NATIONS, 'England'].flatten

    countries.each { |country| return country if flattened_results.include?(country) }
  end
end
