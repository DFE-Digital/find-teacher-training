# frozen_string_literal: true

require 'rails_helper'

describe 'HTTP errors' do
  it 'returns not found' do
    get '/404'
    expect(response).to have_http_status(:not_found)
  end

  it 'returns internal_server_error' do
    get '/500'
    expect(response).to have_http_status(:internal_server_error)
  end

  it 'returns unprocessable_entity' do
    get '/422'
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
