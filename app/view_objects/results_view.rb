class ResultsView
  def initialize(query_parameters:)
    @query_parameters = query_parameters
  end

  def query_parameters_with_defaults
    query_parameters.except("utf8", "authenticity_token")
      .merge(qualifications_parameters)
      .merge(fulltime_parameters)
      .merge(parttime_parameters)
      .merge(hasvacancies_parameters)
      .merge(sen_courses_parameters)
  end

  def filter_path_with_unescaped_commas(base_path)
    "#{base_path}?#{URI.encode_www_form(query_parameters_with_defaults)}".gsub("%2C", ",")
  end

  def fulltime?
    query_parameters["fulltime"].present? && query_parameters["fulltime"].downcase == "true"
  end

  def parttime?
    query_parameters["parttime"].present? && query_parameters["parttime"].downcase == "true"
  end

  def hasvacancies?
    query_parameters["hasvacancies"].blank? || query_parameters["hasvacancies"].downcase == "true"
  end

  def qts_only?
    qualifications_parameters_array.include?("QtsOnly")
  end

  def pgce_or_pgde_with_qts?
    qualifications_parameters_array.include?("PgdePgceWithQts")
  end

  def other_qualifications?
    qualifications_parameters_array.include?("Other")
  end

  def all_qualifications?
    qts_only? && pgce_or_pgde_with_qts? && other_qualifications?
  end

  def with_salaries?
    query_parameters["funding"] == "8"
  end

private

  attr_reader :query_parameters

  def qualifications_parameters
    { "qualifications" => query_parameters["qualifications"].presence || "QtsOnly,PgdePgceWithQts,Other" }
  end

  def fulltime_parameters
    { "fulltime" => fulltime?.to_s.humanize }
  end

  def parttime_parameters
    { "parttime" => parttime?.to_s.humanize }
  end

  def hasvacancies_parameters
    { "hasvacancies" => hasvacancies?.to_s.humanize }
  end

  def sen_courses_parameters
    { "senCourses" => query_parameters["senCourses"].presence || "False" }
  end

  def qualifications_parameters_array
    qualifications_parameters["qualifications"].split(",")
  end
end
