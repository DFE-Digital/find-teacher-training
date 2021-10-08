module ResultFilters
  class SubjectController < ApplicationController
    include FilterParameters

    before_action :build_results_filter_query_parameters
    before_action :build_subject_areas, except: [:create]

    before_action { params['senCourses'].downcase! if params['senCourses'].present? }

    def new; end

    def start
      flash[:start_wizard] = true
    end

    def create
      if params[:subject_codes].blank? && (params[:senCourses].blank? || params[:senCourses] == 'false')
        flash[:error] = [I18n.t('subject_filter.errors.no_option')]

        if flash[:start_wizard]
          redirect_to(start_subject_path(filter_params))
        else
          redirect_to subject_path(filter_params)
        end
      else
        redirect_to results_path(filter_params.merge(subject_codes: params[:subject_codes]))
      end
    end

  private

    def build_subject_areas
      @subject_areas = SubjectArea.includes(:subjects).all
    end

    def build_results_filter_query_parameters
      @results_filter_query_parameters = ResultsView.new(query_parameters: request.query_parameters)
        .query_parameters_with_defaults
    end
  end
end
