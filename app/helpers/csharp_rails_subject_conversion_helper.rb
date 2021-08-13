# These functions are barely tested and temporary, they should be removed when the results page is filtering in Rails
module CsharpRailsSubjectConversionHelper
  def convert_csharp_subject_id_params_to_subject_code
    subjects = if params['subjects'].is_a?(String)
                 params['subjects'].split(',')
               else
                 params['subjects']
               end

    subjects&.map do |subject|
      csharp_to_subject_code(csharp_id: subject)
    end
  end

  def convert_subject_code_params_to_csharp
    params['subjects']&.map do |subject|
      subject_code_to_csharp_subject_id(subject_id: subject)
    end
  end

  def csharp_array_to_subject_codes(csharp_id_array)
    csharp_id_array&.map { |csharp_id| csharp_to_subject_code(csharp_id: csharp_id) }
  end

  def csharp_to_subject_code(csharp_id:)
    rails_data = csharp_subject_code_conversion_table.find do |entry|
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

  def subject_code_to_csharp_subject_id(subject_id:)
    csharp_data = csharp_subject_code_conversion_table.find do |entry|
      entry[:subject_code] == subject_id
    end

    return '[non-existent subject id]' if csharp_data.nil?

    csharp_data[:csharp_id]
  end

  def csharp_subject_code_conversion_table
    @@subject_codes ||= Rails.application.config_for(:subject_codes)['subject_codes'].map(&:symbolize_keys)
  end
end
