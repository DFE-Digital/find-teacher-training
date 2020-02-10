class ProviderSuggestionsController < ApplicationController
  def index
    suggestions = ProviderSuggestion.suggest(params[:query])
      .map { |provider| { code: provider.provider_code, name: provider.provider_name } }
    render json: suggestions
  end
end
