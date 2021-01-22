class ProviderSuggestionsController < ApplicationController
  def index
    return render(json: { error: 'Bad request' }, status: :bad_request) if params_invalid?

    sanitised_query = CGI.escape(params[:query])
    suggestions = ProviderSuggestion
      .select(:code, :name)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .with_params(query: sanitised_query)
      .all
      .map { |provider| { code: provider.code, name: provider.name } }
    render json: suggestions
  end

private

  def params_invalid?
    params[:query].nil? || params[:query].length < 3
  end
end
