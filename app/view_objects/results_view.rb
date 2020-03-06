require "geokit"
class ResultsView
  include CsharpRailsSubjectConversionHelper

  MAXIMUM_NUMBER_OF_SUBJECTS = 43
  NUMBER_OF_SUBJECTS_DISPLAYED = 4
  DISTANCE = "2".freeze

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
      .merge(subject_parameters)
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

  def number_of_extra_subjects
    return 37 if number_of_subjects_selected == MAXIMUM_NUMBER_OF_SUBJECTS

    number_of_subjects_selected - NUMBER_OF_SUBJECTS_DISPLAYED
  end

  def location
    query_parameters["loc"] || "Across England"
  end

  def radius
    query_parameters["rad"]
  end

  def sort_by
    query_parameters["sortby"]
  end

  def show_map?
    latitude.present? && longitude.present? && radius.present?
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

  def location_filter?
    query_parameters["l"] == "1"
  end

  def england_filter?
    query_parameters["l"] == "2"
  end

  def provider_filter?
    query_parameters["l"] == "3"
  end

  def vacancy_filter?
    query_parameters["hasvacancies"] == "False"
  end

  def sort_by_distance?
    sort_by == DISTANCE
  end

  def sort_options
    if location_filter?
      [
        ["Training provider (A-Z)", 0, { "data-qa": "sort-form__options__ascending" }],
        ["Training provider (Z-A)", 1, { "data-qa": "sort-form__options__descending" }],
        ["Distance", 2, { "data-qa": "sort-form__options__distance" }],
      ]
    else
      [["Training provider (A-Z)", 0, { "data-qa": "sort-form__options__ascending" }],
       ["Training provider (Z-A)", 1, { "data-qa": "sort-form__options__descending" }]]
    end
  end

  def courses
    @courses ||= begin
                   base_query = Course
                     .includes(:provider).includes(:sites).includes(:subjects)
                     .where(recruitment_cycle_year: Settings.current_cycle)

                   base_query = base_query.where(funding: "salary") if with_salaries?
                   base_query = base_query.where(vacancies: hasvacancies?)
                   base_query = base_query.where(study_type: study_type) if study_type.present?

                   base_query = base_query.where(qualification: qualification.join(",")) unless all_qualifications?
                   base_query = base_query.where(subjects: subject_codes.join(",")) if subject_codes.any?
                   base_query = base_query.where(send_courses: true) if send_courses?

                   if location_filter?
                     base_query = base_query.where("latitude" => latitude)
                     base_query = base_query.where("longitude" => longitude)
                     base_query = base_query.where("radius" => radius)
                   end

                   base_query = base_query.where("provider.provider_name" => provider) if provider.present?

                   base_query = if sort_by_distance?
                                  base_query.order(:distance)
                                else
                                  base_query
                                    .order("provider.provider_name": results_order)
                                    .order("name": results_order)
                                end

                   base_query
                     .page(query_parameters[:page] || 1)
                     .per(10)
                 end
  end

  def course_count
    courses.meta["count"]
  end

  def site_distance(course)
    distances = course.sites.map do |site|
      lat_long.distance_to("#{site[:latitude]},#{site[:longitude]}")
    end

    min_distance = distances.min

    if min_distance < 1
      min_distance.round(1)
    else
      min_distance.round(0)
    end
  end

  def nearest_address(course)
    ordered_sites = course.sites.sort_by do |site|
      lat_long.distance_to("#{site[:latitude]},#{site[:longitude]}")
    end

    sites_addresses = ordered_sites.map do |address|
      [
        address.address1,
        address.address2,
        address.address3,
        address.address4,
        address.postcode,
      ].select(&:present?).join(", ").html_safe
    end

    sites_addresses.first
  end

  def subjects
    subject_codes.any? ? filtered_subjects : all_subjects[0...NUMBER_OF_SUBJECTS_DISPLAYED]
  end

private

  def qualification
    qualification = []
    qualification |= %w[qts] if qts_only?
    qualification |= %w[pgce_with_qts pgde_with_qts] if pgce_or_pgde_with_qts?
    qualification |= %w[pgce pgde] if other_qualifications?
    qualification
  end

  def lat_long
    Geokit::LatLng.new(latitude.to_f, longitude.to_f)
  end

  attr_reader :query_parameters

  def results_order
    return :desc if query_parameters[:sortby] == "1"

    :asc
  end

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

  def subject_parameters
    query_parameters["subjects"].present? ? { "subjects" => query_parameters["subjects"].presence } : {}
  end

  def subject_parameters_array
    (subject_parameters["subjects"] || "").split(",")
  end

  def subject_codes
    csharp_array_to_subject_codes(subject_parameters_array)
  end

  def latitude
    query_parameters["lat"]
  end

  def longitude
    query_parameters["lng"]
  end

  def google_map_zoom
    case radius
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

  def qualifications
    query_parameters["qualifications"] || "QtsOnly,PgdePgceWithQts,Other"
  end

  def filtered_subjects
    all_matching = all_subjects.select { |subject| subject_codes.include?(subject.subject_code) }
    all_matching[0...NUMBER_OF_SUBJECTS_DISPLAYED]
  end

  def all_subjects
    @all_subjects ||= SubjectArea.includes(:subjects).all
      .map(&:subjects).flatten.sort_by(&:subject_name)
  end

  def number_of_subjects_selected
    subject_parameters_array.any? ? subject_parameters_array.length : all_subjects.count
  end
end
