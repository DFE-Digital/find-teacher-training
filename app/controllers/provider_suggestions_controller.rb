class ProviderSuggestionsController < ApplicationController
  def index
    return render(json: { error: "Bad request" }, status: :bad_request) if params_invalid?

    suggestions = ProviderSuggestion.suggest(params[:query])
      .map { |provider| { code: provider.provider_code, name: provider.provider_name } }
    render json: suggestions
  end

private

  def params_invalid?
    params[:query].nil? || params[:query].length < 3
  end
end
