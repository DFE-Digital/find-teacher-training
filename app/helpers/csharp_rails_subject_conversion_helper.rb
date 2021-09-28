# These functions are being used to map bookmarked requests. This module should be deleted at the end of 2021
module CsharpRailsSubjectConversionHelper
  def convert_csharp_subject_id_params_to_subject_code(csharp_subjects)
    subjects = if csharp_subjects.is_a?(String)
                 csharp_subjects.split(',')
               else
                 csharp_subjects
               end

    subjects&.map do |subject|
      csharp_to_subject_code(csharp_id: subject)
    end
  end

  def csharp_to_subject_code(csharp_id:)
    rails_data = subject_codes.find do |entry|
      entry[:csharp_id] == csharp_id
    end

    # A user may somehow end up with a subject that doesn't exist.
    # If we weren't converting subject IDs, this wouldn't be an issue
    # but since we are, we will just return a subject id that will never exist.
    # This workaround means that removing this entire module will be easier in
    # future because we don't need to do any extra work to ensure a subject
    # exists.
    return '[non-existent subject code]' if rails_data.nil?

    rails_data[:subject_code]
  end

  def subject_codes
    @subject_codes ||= Rails.application.config_for(:subject_codes)['subject_codes'].map(&:symbolize_keys)
  end
end
