module Search
  class SubjectsController < ApplicationController
    include FilterParameters

    before_action :build_backlink_query_parameters

    def new
      @subjects_form = Search::SubjectsForm.new(subject_codes: params[:subject_codes], age_group: params[:age_group])
    end

    def create
      @subjects_form = Search::SubjectsForm.new(subject_codes: sanitised_subject_codes, age_group: form_params[:age_group])

      if @subjects_form.valid?
        redirect_to results_path(filter_params[:search_subjects_form].merge(subject_codes: @subjects_form.subject_codes))
      else
        render :new
      end
    end

  private

    def sanitised_subject_codes
      form_params['subject_codes'].delete_if(&:blank?)
    end

    def form_params
      params
        .require(:search_subjects_form)
        .permit(:age_group, subject_codes: [])
    end

    def build_backlink_query_parameters
      @backlink_query_parameters = ResultsView.new(query_parameters: request.query_parameters)
                                              .query_parameters_with_defaults
                                              .except(:search_subjects_form)
    end
  end
end
