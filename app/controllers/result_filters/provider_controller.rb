module ResultFilters
  class ProviderController < ApplicationController
    include FilterParameters
    include QuerySanitizer

    def new
      if params[:query].blank?
        flash[:error] = [I18n.t("location_filter.fields.provider")]
        return redirect_back
      end

      @provider_suggestions = Provider
        .select(:provider_code, :provider_name)
        .where(recruitment_cycle_year: Settings.current_cycle)
        .with_params(search: sanitized_params["query"])
        .all

      if @provider_suggestions.count.zero?
        flash[:error] = [I18n.t("location_filter.fields.provider")]
        redirect_back
      elsif @provider_suggestions.count == 1
        redirect_to results_path(sanitized_params.merge(query: @provider_suggestions.first.provider_name))
      end
    end

    def redirect_back
      redirect_params = sanitized_params
      redirect_params = redirect_params.except(:query) if params[:query].blank?

      redirect_to location_path(redirect_params)
    end

    def sanitized_params
      query = filter_params["query"]
      @sanitized_params ||= filter_params.clone.merge("query" => strip_non_ascii(query))
    end
  end
end
