require 'rails_helper'

describe 'results/non_university.html.erb', type: :view do
  let(:html) do
    render partial: 'results/non_university', locals: {
      course: course,
      number_of_locations: number_of_locations,
      nearest_address: '10 Windy Way, Witham, Essex, UK, CM8 2SD',
      nearest_location_name: 'campus main site',
      location_distance: 0.1,
    }
  end

  let(:parameter_hash) { { 'lat' => '51.4975', 'lng' => '0.1357' } }

  let(:course) { build(:course) }

  before do
    assign(:results_view, ResultsView.new(query_parameters: parameter_hash))
  end

  context 'single location' do
    let(:number_of_locations) { 1 }

    it 'renders dt with Location' do
      expect(html).to have_css('dt.govuk-list--description__label', text: 'Location')
      expect(html).to have_no_css('dt.govuk-list--description__label', text: 'Nearest location')
    end

    it "renders '0.1 miles from you'" do
      expect(html).to match('0.1 miles from you')
    end

    it "does not renders 'locations to choose from'" do
      expect(html).to have_no_css('div.govuk-\\!-margin-top-0')
      expect(html).not_to match('locations to choose from')
    end

    it 'does not renders `Main Site` as nearest_location_name' do
      expect(html).not_to match('Main Site')
    end

    it "renders nearest address'" do
      expect(html).to match('10 Windy Way, Witham, Essex, UK, CM8 2SD')
    end

    it 'renders location' do
      expect(html).to have_css('span.govuk-list--description__hint.govuk-\\!-padding-top-2', text: 'Location')
    end
  end

  context 'multiple locations' do
    let(:number_of_locations) { 2 }

    it 'renders dt with Nearest location' do
      expect(html).to have_no_css('dt.govuk-list--description__label', text: 'Location')
      expect(html).to have_css('dt.govuk-list--description__label', text: 'Nearest location')
    end

    it 'renders choose from' do
      expect(html).to have_css('div.govuk-\\!-margin-top-0', text: '(Nearest of 2 locations to choose from)')
    end

    it 'renders nearest location name' do
      expect(html).to match('campus main site')
    end

    it "renders nearest address'" do
      expect(html).to match('10 Windy Way, Witham, Essex, UK, CM8 2SD')
    end

    it 'renders location' do
      expect(html).to have_css('span.govuk-list--description__hint.govuk-\\!-padding-top-2', text: 'Location')
    end
  end
end
