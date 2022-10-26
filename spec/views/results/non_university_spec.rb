require 'rails_helper'

describe 'results/non_university.html.erb' do
  let(:html) do
    render partial: 'results/non_university', locals: { course: }
  end

  let(:site1) do
    build(
      :site,
      latitude: 51.4985,
      longitude: 0.1367,
      address1: '10 Windy Way',
      address2: 'Witham',
      address3: 'Essex',
      address4: 'UK',
      postcode: 'CM8 2SD',
    )
  end

  let(:parameter_hash) { { 'lat' => '51.4975', 'lng' => '0.1357' } }

  let(:course) do
    build(:course, site_statuses:)
  end

  before do
    assign(:results_view, ResultsView.new(query_parameters: parameter_hash))
  end

  context 'single site' do
    let(:site_statuses) do
      [
        build(:site_status, :full_time_and_part_time, site: site1),
      ]
    end

    it 'renders dt with Location' do
      expect(html).to have_css('dt.app-description-list__label', text: 'Location')
      expect(html).not_to have_css('dt.app-description-list__label', text: 'Nearest location')
    end

    it "renders '0.1 miles from you'" do
      expect(html).to match('0.1 miles from you')
    end

    it "does not renders 'locations to choose from'" do
      expect(html).not_to have_css('div.govuk-\\!-margin-top-0')
      expect(html).not_to match('locations to choose from')
    end

    it 'does not renders `Main Site` as nearest_location_name' do
      expect(html).not_to match('Main Site')
    end

    it "renders nearest address'" do
      expect(html).to match('10 Windy Way, Witham, Essex, UK, CM8 2SD')
    end

    it 'renders location' do
      expect(html).to have_css('span.app-description-list__hint.govuk-\\!-padding-top-2', text: 'Location')
    end
  end

  context 'multi sites' do
    let(:site2) do
      build(
        :site,
        latitude: 51.4980,
        longitude: 0.1367,
        address1: '101 Windy Way',
        address2: 'Witham',
        address3: 'Essex',
        address4: 'UK',
        postcode: 'CM8 2SD',
        location_name: 'campus main site',
      )
    end
    let(:site_statuses) do
      [
        build(:site_status, :full_time_and_part_time, site: site1),
        build(:site_status, :full_time_and_part_time, site: site2),
      ]
    end

    it 'renders dt with Nearest location' do
      expect(html).not_to have_css('dt.app-description-list__label', text: 'Location')
      expect(html).to have_css('dt.app-description-list__label', text: 'Nearest location')
    end

    it 'renders choose from' do
      expect(html).to have_css('div.govuk-\\!-margin-top-0', text: '(Nearest of 2 locations to choose from)')
    end

    it 'renders nearest location name' do
      expect(html).to match('campus main site')
    end

    it "renders nearest address'" do
      expect(html).to match('101 Windy Way, Witham, Essex, UK, CM8 2SD')
    end

    it 'renders location' do
      expect(html).to have_css('span.app-description-list__hint.govuk-\\!-padding-top-2', text: 'Location')
    end
  end
end
