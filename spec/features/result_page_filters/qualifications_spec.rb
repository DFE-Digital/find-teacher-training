require 'rails_helper'

RSpec.feature 'Qualifications filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include FiltersFeatureSpecsHelper

  scenario 'Candidate applies qualifications filters on results page' do
    when_i_visit_the_results_page
    then_i_see_all_qualifications_checkboxes_are_selected

    when_i_unselect_the_pgce_and_further_education_qualification_checkboxes
    and_apply_the_filters
    then_i_see_that_the_pgce_and_further_education_qualification_checkboxes_are_still_unselected
    and_the_qts_checkbox_is_selected
    and_the_qts_qualification_query_parameters_are_retained

    when_i_select_the_pgce_qualification_checkbox
    and_i_deselect_the_qts_qualification_checkbox
    and_apply_the_filters
    then_i_see_that_the_qts_and_further_education_checkboxes_are_still_unselected
    and_the_pgce_checkbox_is_selected
    and_the_pgce_qualification_query_parameters_are_retained

    when_i_select_the_further_education_checkbox
    and_i_deselect_the_pgce_checkbox
    and_apply_the_filters
    then_i_see_that_the_pgce_and_qts_checkboxes_are_still_unselected
    and_the_further_education_checkbox_is_selected
    and_the_further_education_qualification_query_parameters_are_retained
  end

  def then_i_see_all_qualifications_checkboxes_are_selected
    expect(results_page.qualifications_filter.legend.text).to eq('Qualifications filter')
    expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(true)
    expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(true)
    expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(true)
  end

  def when_i_unselect_the_pgce_and_further_education_qualification_checkboxes
    stub_courses(
      query: results_page_parameters.merge(
        'filter[qualification]' => 'qts',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.qualifications_filter.pgce_checkbox.uncheck
    results_page.qualifications_filter.further_education_checkbox.uncheck
  end

  def then_i_see_that_the_pgce_and_further_education_qualification_checkboxes_are_still_unselected
    expect(results_page.qualifications_filter.legend.text).to eq('Qualifications filter')
    expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(false)
    expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(false)
  end

  def and_the_qts_checkbox_is_selected
    expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(true)
  end

  def and_the_qts_qualification_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'show_all_courses',
        'qualifications' => %w[QtsOnly],
      },
    )
  end

  def when_i_select_the_pgce_qualification_checkbox
    stub_courses(
      query: results_page_parameters.merge(
        'filter[qualification]' => 'pgce_with_qts,pgde_with_qts',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.qualifications_filter.pgce_checkbox.check
  end

  def and_i_deselect_the_qts_qualification_checkbox
    results_page.qualifications_filter.qts_checkbox.uncheck
  end

  def then_i_see_that_the_qts_and_further_education_checkboxes_are_still_unselected
    expect(results_page.qualifications_filter.legend.text).to eq('Qualifications filter')
    expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(false)
    expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(false)
  end

  def and_the_pgce_checkbox_is_selected
    expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(true)
  end

  def and_the_pgce_qualification_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'show_all_courses',
        'qualifications' => %w[PgdePgceWithQts],
      },
    )
  end

  def when_i_select_the_further_education_checkbox
    stub_courses(
      query: results_page_parameters.merge(
        'filter[qualification]' => 'pgce,pgde',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.qualifications_filter.further_education_checkbox.check
  end

  def and_i_deselect_the_pgce_checkbox
    results_page.qualifications_filter.pgce_checkbox.uncheck
  end

  def then_i_see_that_the_pgce_and_qts_checkboxes_are_still_unselected
    expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(false)
    expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(false)
  end

  def and_the_further_education_checkbox_is_selected
    expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(true)
  end

  def and_the_further_education_qualification_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'show_all_courses',
        'qualifications' => %w[Other],
      },
    )
  end
end
