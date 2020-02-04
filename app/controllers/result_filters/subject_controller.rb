module ResultFilters
  class SubjectController < ApplicationController
    include FilterParameters
    include CsharpRailsSubjectConversionHelper
    before_action { params["senCourses"].downcase! if params["senCourses"].present? }

    def new
      params["subjects"] = convert_csharp_subject_id_params_to_rails if convert_csharp_subject_id_params_to_rails.present?
      @subject_areas = SubjectArea.includes(:subjects).all
    end

    def create
      redirect_to results_path(filter_params.merge(subjects: convert_rails_subject_id_params_to_csharp))
    end
  end
end
