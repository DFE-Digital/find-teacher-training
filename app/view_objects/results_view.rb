class ResultsView
  NUMBER_OF_SUBJECTS_DISPLAYED = 4

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

  def send_courses?
    query_parameters["senCourses"].present? && query_parameters["senCourses"].downcase == "true"
  end

  def number_of_subjects_selected
    if query_parameters["subjects"].blank?
      return SubjectArea.includes(:subjects).all
        .map(&:subjects).flatten.length
    end

    query_parameters["subjects"].split(",").count
  end

  def number_of_extra_subjects
    number_of_subjects_selected - NUMBER_OF_SUBJECTS_DISPLAYED
  end

  def location
    query_parameters["loc"] || "Across England"
  end

  def distance
    query_parameters["rad"]
  end

  def show_map?
    latitude.present? && longitude.present? && distance.present?
  end

  def map_image_url
    "#{Settings.google.maps_api_url}\
    ?key=#{Settings.google.maps_api_key}\
    &center=#{latitude},#{longitude}\
    &zoom=#{google_map_zoom}\
    &size=300x200\
    &scale=2\
    &markers=#{latitude},#{longitude}"
  end

  def provider
    query_parameters["query"]
  end

  def provider_filter?
    query_parameters["l"] == "3"
  end

  def courses
    @courses ||= begin
                   base_query = Course
                     .includes(:provider)
                     .where(recruitment_cycle_year: Settings.current_cycle)

                   base_query = base_query.where(funding: "salary") if with_salaries?
                   base_query = base_query.where(vacancies: hasvacancies?)
                   base_query = base_query.where(study_type: study_type) if study_type.present?

                   base_query
                     .page(query_parameters[:page] || 1)
                     .per(10)
                 end
  end

  def total_course_count
    courses.total_count
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

  def latitude
    query_parameters["lat"]
  end

  def longitude
    query_parameters["lng"]
  end

  def google_map_zoom
    case distance
    when "5"
      "12"
    when "10"
      "11"
    when "20"
      "10"
    when "50"
      "9"
    when "100"
      "8"
    else
      "14"
    end
  end

  def study_type
    return "full_time,part_time" if fulltime? && parttime?
    return "full_time" if fulltime?
    return "part_time" if parttime?
  end
end
