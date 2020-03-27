class SuggestedSearchLink
  include ActionView::Helpers::TextHelper
  attr_reader :radius, :count, :parameters, :including_non_salaried

  def initialize(radius:, count:, parameters:, including_non_salaried: false)
    @radius = radius
    @count = count
    @parameters = parameters
    @including_non_salaried = including_non_salaried
  end

  def text
    count_prefix = "#{pluralize(count, 'course')} #{'with or without a salary ' if including_non_salaried}"
    count_prefix + (all_england? ? "across England" : "within #{radius} miles")
  end

  def url
    UnescapedQueryStringService.call(
      base_path: Rails.application.routes.url_helpers.results_path,
      parameters: suggested_search_link_parameters(radius: radius),
    )
  end

private

  def all_england?
    radius.nil?
  end

  def suggested_search_link_parameters(radius:)
    return parameters.merge("rad" => radius) if radius.present?

    parameters
      .reject { |k, _v| %w(lat lng rad loc lq).include?(k) }
      .merge("l" => 2)
  end
end
