module ResultFilters
  module SubjectHelper
    include FilterParameters
    include CsharpRailsSubjectConversionHelper

    def subject_is_selected?(subject_code:)
      if params['subjects'] && params['subjects'].length
        subject_code.in?(params['subjects'])
      else
        false
      end
    end

    def subject_area_is_selected?(subject_area:)
      return false if params['subjects'].nil?

      (params['subjects'] & subject_area.subjects.map(&:id)).any?
    end

    def no_subject_selected_error?
      return false if flash[:error].nil?

      flash[:error].include?(I18n.t('subject_filter.errors.no_option'))
    end

    def filtered_subject_names
      request.params['subjects']
             .map { |csharp_id|
               csharp_data = csharp_subject_code_conversion_table.find do |entry|
                 entry[:csharp_id] == csharp_id
               end
               csharp_data[:name]
             }
             .sort
             .join(', ')
    end
  end
end
