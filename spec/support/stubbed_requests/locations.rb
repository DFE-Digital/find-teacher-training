module StubbedRequests
  module Locations
    def stub_locations(query:)
      stub_request(
        :get,
        /locations/,
      )
        .with(query: query)
        .to_return(
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          body: File.new('spec/fixtures/teacher_training_api/public/v1/one_location.json'),
        )
    end

    def stub_location_with_no_address(query:)
      stub_request(
        :get,
        /locations/,
      )
        .with(query: query)
        .to_return(
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          body: File.new('spec/fixtures/teacher_training_api/public/v1/one_location_no_address.json'),
        )
    end
  end
end
