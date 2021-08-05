require 'rails_helper'

describe '/start', type: :request do
  it "redirects from '/start/location' to '/'" do
    get '/start/location'

    expect(response).to redirect_to('/')
  end
end
