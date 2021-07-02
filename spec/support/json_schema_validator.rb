class JSONSchemaValidator
  attr_reader :schema, :json

  def initialize(schema, json)
    @schema = schema
    @json = json
  end

  def valid?
    formatted_validation_errors.blank?
  end

  def failure_message
    <<~ERROR
      Expected the JSON structure to be valid against the provided schema:

      #{formatted_item}

      But I got these validation errors:

      #{formatted_validation_errors}

    ERROR
  end

private

  def formatted_validation_errors
    errors = JSON::Validator.fully_validate(schema, json)
    errors.map { |message| "- #{humanized_error(message)}" }.join("\n")
  end

  def formatted_item
    return json if json.is_a?(String)

    JSON.pretty_generate(json)
  end

  def humanized_error(message)
    message.gsub("The property '#/'", "The (root) property '#/'")
  end
end
