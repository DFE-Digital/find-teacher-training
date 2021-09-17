module ResultFilters
  module SubjectHelper
    include FilterParameters
    include CsharpRailsSubjectConversionHelper

    def subject_is_selected?(subject_code:)
      if !params['rails_subjects']&.length.nil?
        subject_code.in?(params['rails_subjects'])
      else
        false
      end
    end

    def subject_area_is_selected?(subject_area:)
      return false if params['rails_subjects'].nil?

      (params['rails_subjects'] & subject_area.subjects.map(&:subject_code)).any?
    end

    def no_subject_selected_error?
      return false if flash[:error].nil?

      flash[:error].include?(I18n.t('subject_filter.errors.no_option'))
    end

    def filtered_subject_names
      request.params['subjects']
             .map { |csharp_id|
               csharp_data = CsharpRailsSubjectConversionHelper.subject_codes.find do |entry|
                 entry[:csharp_id] == csharp_id
               end
               csharp_data[:name]
             }
             .sort
             .join(', ')
    end
  end
end
