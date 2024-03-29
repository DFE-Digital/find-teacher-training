module Search
  class AgeGroupsController < ApplicationController
    include FilterParameters

    before_action :build_backlink_query_parameters

    def new
      @age_groups_form = AgeGroupsForm.new(age_group: params[:age_group])
    end

    def create
      @age_groups_form = AgeGroupsForm.new(age_group: form_params[:age_group])

      if @age_groups_form.valid?
        if form_params[:age_group] == 'further_education'
          redirect_to results_path(further_education_params)
        else
          redirect_to subjects_path(filter_params[:search_age_groups_form])
        end
      else
        render :new
      end
    end

  private

    def further_education_params
      filter_params[:search_age_groups_form].merge(age_group: @age_groups_form.age_group, subject_codes: ['41'])
    end

    def form_params
      params
        .require(:search_age_groups_form)
        .permit(:age_group)
    end

    def build_backlink_query_parameters
      @backlink_query_parameters = ResultsView.new(query_parameters: request.query_parameters)
                                              .query_parameters_with_defaults
                                              .except(:search_age_groups_form)
    end
  end
end
