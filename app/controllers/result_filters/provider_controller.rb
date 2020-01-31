module ResultFilters
  class ProviderController < ApplicationController
    include FilterParameters

    def new
      if params[:query].blank?
        flash[:error] = "Training provider"
        return redirect_back
      end

      @provider_suggestions = Provider
        .select(:provider_code, :provider_name)
        .where(recruitment_cycle_year: "2020")
        .with_params(search: params[:query])
        .all

      if @provider_suggestions.count.zero?
        flash[:error] = "Training provider"
        redirect_back
      elsif @provider_suggestions.count == 1
        redirect_to results_path(filter_params.merge(query: @provider_suggestions.first.provider_name))
      end
    end

    def redirect_back
      redirect_to location_path(filter_params)
    end
  end
end
