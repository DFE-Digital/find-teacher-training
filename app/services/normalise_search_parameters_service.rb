class NormaliseSearchParametersService
  BOOLEAN_PARAMETER_NAMES = %w[fulltime hasvacancies parttime senCourses].freeze
  ARRAY_PARAMETER_NAMES = %w[qualifications subjects subject_codes].freeze

  def call(parameters:)
    params_hash = parameters
    invalid_params_present = false

    BOOLEAN_PARAMETER_NAMES.each do |parameter_name|
      if is_legacy_boolean?(parameters[parameter_name])
        invalid_params_present = true
        params_hash = params_hash.merge(parameter_name => legacy_to_rails_boolean(parameters[parameter_name]))
      end
    end

    ARRAY_PARAMETER_NAMES.each do |parameter_name|
      if is_legacy_array?(parameters[parameter_name])
        params_hash = params_hash.merge(parameter_name => legacy_to_rails_array(parameters[parameter_name]))
        invalid_params_present = true
      end
    end

    if invalid_params_present
      Rails.logger.warn('The user navigated to the results page using the deprecated or invalid parameters') if Rails.env.production?
      return { deprecated: true, parameters: params_hash }
    end

    return { deprecated: false, parameters: params_hash }
  end

private

  def is_legacy_boolean?(value)
    value.in?(%w[True False])
  end

  def is_legacy_array?(value)
    value.present? && !value.instance_of?(Array)
  end

  def legacy_to_rails_array(array)
    if array.instance_of?(String)
      array.split(',')
    elsif array.is_a?(Hash)
      array.values
    end
  end

  def legacy_to_rails_boolean(boolean)
    boolean == 'True'
  end
end

