require 'rails_helper'

RSpec.feature 'Searching by provider' do
  include StubbedRequests::Providers

  scenario 'Candidate searches by provider' do
    given_that_the_new_search_flow_feature_flag_is_enabled
    and_the_provider_cache_is_enabled

    when_i_visit_the_start_page
    and_i_select_the_provider_radio_button
    and_i_click_continue
    then_i_should_see_a_missing_provider_validation_error

    when_i_select_the_provider
    and_i_click_continue
    then_i_should_see_the_age_groups_form
    and_the_correct_age_group_form_page_url_and_query_params_are_present

    when_i_click_back
    then_i_should_see_the_start_page
    and_the_provider_radio_button_is_selected

    # Note that the remainder of the search flow is has
    # test coverage in 'spec/features/new_flow/across_england'
  end

  def given_that_the_new_search_flow_feature_flag_is_enabled
    allow(FeatureFlag).to receive(:active?).and_call_original
    allow(FeatureFlag).to receive(:active?).with(:new_search_flow).and_return(true)
  end

  def and_the_provider_cache_is_enabled
    cached_providers = [
      {
        name: 'Provider 1',
        code: 'ABC',
      },
    ].to_json

    allow(TeacherTrainingPublicAPI::ProvidersCache).to receive(:read).and_return(cached_providers)

    stub_one_provider(
      query: {
        'fields[providers]' => 'provider_code,provider_name',
        'search' => 'Provider 1 (ABC)',
      },
    )
  end

  def when_i_visit_the_start_page
    visit root_path
  end

  def and_i_select_the_provider_radio_button
    choose 'By school, university or other training provider'
  end

  def and_i_click_continue
    click_button 'Continue'
  end

  def then_i_should_see_a_missing_provider_validation_error
    expect(page).to have_content('Enter a school, university or other training provider')
  end

  def when_i_select_the_provider
    select 'Provider 1 (ABC)', from: 'query'
  end

  def then_i_should_see_the_age_groups_form
    expect(page).to have_content(I18n.t('age_groups.title'))
  end

  def and_the_correct_age_group_form_page_url_and_query_params_are_present
    URI(current_url).then do |uri|
      expect(uri.path).to eq('/age-groups')
      expect(uri.query).to eq('l=3&query=ACME+SCITT+0')
    end
  end

  def then_i_should_see_the_start_page
    expect(page).to have_content('Find courses by location or by training provider')
  end

  def when_i_click_back
    click_link 'Back'
  end

  def and_the_provider_radio_button_is_selected
    expect(find_field('By school, university or other training provider')).to be_checked
  end
end
