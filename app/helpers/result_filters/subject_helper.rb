module ResultFilters
  module SubjectHelper
    include FilterParameters

    def subject_is_selected?(subject_code:)
      if params['subject_codes']&.length.nil?
        false
      else
        subject_code.in?(params['subject_codes'])
      end
    end

    def subject_area_is_selected?(subject_area:)
      return false if params['subject_codes'].nil?

      params['subject_codes'].intersect?(subject_area.subjects.map(&:subject_code))
    end

    def no_subject_selected_error?
      return false if flash[:error].nil?

      flash[:error].include?(I18n.t('subject_filter.errors.no_option'))
    end
  end
end
