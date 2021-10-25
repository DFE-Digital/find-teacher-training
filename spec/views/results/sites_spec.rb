require 'rails_helper'

describe 'results/sites.html.erb', type: :view do
  let(:results_view) { ResultsView.new(query_parameters: parameter_hash) }

  let(:html) do
    render partial: 'results/sites', locals: { course: course, results_view: results_view }
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
    build(:course, site_statuses: site_statuses)
  end

  context 'single site' do
    let(:site_statuses) do
      [
        build(:site_status, :full_time_and_part_time, site: site1),
      ]
    end

    it 'renders dt with Location' do
      expect(html).to have_css('dt.app-description-list__label', text: 'Location')
      expect(html).to have_no_css('dt.app-description-list__label', text: 'Number of locations')
    end

    it "renders nearest address'" do
      expect(html).to match('10 Windy Way, Witham, Essex, UK, CM8 2SD')
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
      expect(html).to have_no_css('dt.app-description-list__label', text: 'Location')
      expect(html).to have_css('dt.app-description-list__label', text: 'Number of locations')
    end

    it 'renders the correct count of sites' do
      expect(html).to match('2')
    end
  end
end
