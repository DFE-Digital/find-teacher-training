module Search
  class StartController < ApplicationController
    include FilterParameters

    before_action :check_provider_cache_is_populated

    def new
      @start_form = StartForm.new(
        l: params[:l],
        lq: params[:lq],
        query: params[:query],
      )
    end

    def create
      @start_form = StartForm.new(form_params)

      if @start_form.valid?
        next_step_params = build_params(@start_form)
        redirect_to age_groups_path(next_step_params)
      else
        render :new
      end
    end

  private

    def build_params(form)
      params = filter_params[:search_start_form]

      if form.location_search?
        location_params = GeocoderService.location_params_for(form.lq)
        params.merge!(location_params)
      end

      # TODO: handle provider and across england search.
      # Should this logic be extracted to a class or added to the FilterParameters module??

      strip(params)
    end

    def form_params
      params.require(:search_start_form).permit(:l, :lq, :query)
    end

    def check_provider_cache_is_populated
      if Rails.env.development? && TeacherTrainingPublicAPI::ProvidersCache.read.empty?
        message = 'The TeacherTrainingPublicAPI::ProvidersCache is currently empty. Please run `TeacherTrainingPublicAPI::SyncAllProviders.call` in the Rails console.'
        raise ProviderCacheEmptyError, message
      end
    end

    def strip(params)
      params.reject { |_, v| v == '' }
    end
  end

  class ProviderCacheEmptyError < StandardError; end
end
