module Search
  class StartController < ApplicationController
    include FilterParameters

    before_action :check_provider_cache_is_populated
    # before_action :build_results_filter_query_parameters

    def new
      @start_form = StartForm.new
    end

    def create
      @start_form = StartForm.new(form_params)

      if @start_form.valid?
        redirect_to next_step
      else
        render :new
      end
    end

  private

    def form_params
      params.require(:search_start_form).permit(:l, :lq, :query)
    end

    def check_provider_cache_is_populated
      if Rails.env.development? && TeacherTrainingPublicAPI::ProvidersCache.read.empty?
        message = 'The TeacherTrainingPublicAPI::ProvidersCache is currently empty. Please run `TeacherTrainingPublicAPI::SyncAllProviders.call` in the Rails console.'
        raise ProviderCacheEmptyError, message
      end
    end

    def build_results_filter_query_parameters
      @results_filter_query_parameters = merge_previous_parameters(
        ResultsView.new(query_parameters: request.query_parameters).query_parameters_with_defaults,
      )
    end
  end
end
