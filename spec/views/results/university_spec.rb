require 'rails_helper'

describe 'results/university.html.erb', type: :view do
  let(:html) do
    render partial: 'results/university', locals: {
      course: course,
      location_distance: location_distance,
      placement_schools_summary: placement_schools_summary,
      locations_count: locations_count,
    }
  end

  let(:locations_count) { 1 }
  let(:location_distance) { 0.1 }
  let(:placement_schools_summary) { 'Placement schools are near you' }

  let(:lat_lon) do
    {
      latitude: 51.4985,
      longitude: 0.1367,
    }
  end

  let(:parameter_hash) { { 'lat' => '51.4975', 'lng' => '0.1357' } }

  before do
    assign(:results_view, ResultsView.new(query_parameters: parameter_hash))
  end

  context 'further education course' do
    let(:course) do
      build(:course, :further_education, provider: build(:provider))
    end

    it 'renders University' do
      expect(html).to have_css('span.govuk-list--description__hint.govuk-\\!-margin-top-0', text: 'University')
    end

    it "renders '0.1 miles from you'" do
      expect(html).to match('0.1 miles from you')
    end
  end

  context 'non further education course' do
    let(:course) do
      build(:course, provider: build(:provider))
    end

    it 'renders Placement schools' do
      expect(html).to have_css('span.govuk-list--description__hint.govuk-\\!-margin-top-0', text: 'Placement schools')
    end

    it 'renders link' do
      expect(html).to have_link('More about placements on this course', href: course_path(provider_code: course.provider.code, course_code: course.code, anchor: 'section-schools'), visible: :hidden)
    end

    it 'renders University' do
      expect(html).to have_css('span.govuk-list--description__hint.govuk-\\!-padding-top-2', text: 'University')
    end

    it 'renders dt with Location' do
      expect(html).to have_css('dt.govuk-list--description__label', text: 'Location')
      expect(html).to have_no_css('dt.govuk-list--description__label', text: 'Nearest location')
    end

    context 'site_distance less than 11 miles' do
      it "renders '0.1 miles from you'" do
        expect(html).to match('0.1 miles from you')
      end

      it 'renders Placement schools distance summary' do
        expect(html).to have_css('span.govuk-details__summary-text', text: 'Placement schools are near you')
      end
    end

    context 'site_distance less than 21 miles' do
      let(:lat_lon) do
        { latitude: 51.6985,
          longitude: 0.1367 }
      end

      let(:location_distance) { 14 }
      let(:placement_schools_summary) { 'Placement schools might be near you' }

      it "renders '14 miles from you'" do
        expect(html).to match('14 miles from you')
      end

      it 'renders Placement schools distance summary' do
        expect(html).to have_css('span.govuk-details__summary-text', text: 'Placement schools might be near you')
      end
    end

    context 'site_distance more than 21 miles' do
      let(:lat_lon) do
        { latitude: 52,
          longitude: 0.1367 }
      end

      let(:location_distance) { 35 }
      let(:placement_schools_summary) { 'Placement schools might be in commuting distance' }

      it "renders '35 miles from you'" do
        expect(html).to match('35 miles from you')
      end

      it 'renders Placement schools distance summary' do
        expect(html).to have_css('span.govuk-details__summary-text', text: 'Placement schools might be in commuting distance')
      end
    end

    context 'course has two locations' do
      let(:locations_count) { 2 }

      it "renders '(Nearest of 2 locations to choose from)'" do
        expect(html).to match('(Nearest of 2 locations to choose from)')
      end
    end
  end
end
