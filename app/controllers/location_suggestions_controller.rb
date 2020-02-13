class LocationSuggestionsController < ApplicationController
  def index
    suggestions = LocationSuggestion.suggest(params[:query])
    render json: suggestions
  end
end
