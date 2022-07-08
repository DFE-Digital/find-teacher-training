require 'rails_helper'

RSpec.describe 'handling invalid multipart form data' do
  it 'returns 400 for malformed form data' do
    # POST to /cookies (a valid POST path) so we don't get a 404 exception instead
    post '/cookies', params: 'nonsense', headers: { 'Content-Type' => 'multipart/form-data; boundary=----blah' }
    expect(response).to have_http_status(:bad_request)
  end
end
