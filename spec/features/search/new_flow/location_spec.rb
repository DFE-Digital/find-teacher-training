require 'rails_helper'

RSpec.feature 'Searching by location' do
  before do
    stub_geocoder
  end

  scenario 'Candidate searches by location' do
    given_that_the_new_search_flow_feature_flag_is_enabled

    when_i_visit_the_start_page
    and_i_select_the_location_radio_button
    and_i_click_continue
    then_i_should_see_a_missing_location_validation_error

    when_i_enter_a_location
    and_i_click_continue
    then_i_should_see_the_age_groups_form
    and_the_correct_age_group_form_page_url_and_query_params_are_present

    when_i_click_back
    then_i_should_see_the_start_page
    and_the_location_radio_button_is_selected

    # Note that the remainder of the search flow is has
    # test coverage in 'spec/features/new_flow/across_england'
  end

  def given_that_the_new_search_flow_feature_flag_is_enabled
    allow(FeatureFlag).to receive(:active?).and_call_original
    allow(FeatureFlag).to receive(:active?).with(:new_search_flow).and_return(true)
  end

  def when_i_visit_the_start_page
    visit root_path
  end

  def and_i_select_the_location_radio_button
    choose 'By city, town or postcode'
  end

  def and_i_click_continue
    click_button 'Continue'
  end

  def then_i_should_see_a_missing_location_validation_error
    expect(page).to have_content('Enter a city, town or postcode')
  end

  def when_i_enter_a_location
    fill_in 'Postcode, town or city', with: 'Yorkshire'
  end

  def then_i_should_see_the_age_groups_form
    expect(page).to have_content(I18n.t('age_groups.title'))
  end

  def and_the_correct_age_group_form_page_url_and_query_params_are_present
    URI(current_url).then do |uri|
      expect(uri.path).to eq('/age-groups')
      expect(uri.query).to eq('c=England&l=1&lat=51.4524877&lng=-0.1204749&loc=AA+Teamworks+W+Yorks+SCITT%2C+School+Street%2C+Greetland%2C+Halifax%2C+West+Yorkshire+HX4+8JB&lq=Yorkshire&rad=50&sortby=2')
    end
  end

  def then_i_should_see_the_start_page
    expect(page).to have_content('Find courses by location or by training provider')
  end

  def when_i_click_back
    click_link 'Back'
  end

  def and_the_location_radio_button_is_selected
    expect(find_field('By city, town or postcode')).to be_checked
  end
end
