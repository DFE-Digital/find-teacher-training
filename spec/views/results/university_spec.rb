require 'rails_helper'

describe 'results/university.html.erb' do
  let(:html) do
    render partial: 'results/university', locals: { course: }
  end

  let(:site1) do
    build(
      :site,
      **lat_lon,
      address1: '10 Windy Way',
      address2: 'Witham',
      address3: 'Essex',
      address4: 'UK',
      postcode: 'CM8 2SD',
    )
  end

  let(:lat_lon) do
    {
      latitude: 51.4985,
      longitude: 0.1367,
    }
  end

  let(:parameter_hash) { { 'lat' => '51.4975', 'lng' => '0.1357' } }

  let(:site_statuses) do
    [
      build(:site_status, :full_time_and_part_time, site: site1),
    ]
  end

  before do
    assign(:results_view, ResultsView.new(query_parameters: parameter_hash))
  end

  context 'further education course' do
    let(:course) do
      build(:course, :further_education, provider: build(:provider), site_statuses:)
    end

    it 'renders University' do
      expect(html).to have_css('span.app-description-list__hint.govuk-\\!-margin-top-0', text: 'University')
    end

    it "renders '0.1 miles from you'" do
      expect(html).to match('0.1 miles from you')
    end
  end

  context 'non further education course' do
    let(:course) do
      build(:course, provider: build(:provider), site_statuses:)
    end

    it 'renders Placement schools' do
      expect(html).to have_css('span.app-description-list__hint.govuk-\\!-margin-top-0', text: 'Placement schools')
    end

    it 'renders link' do
      expect(html).to have_link('More about placements on this course', href: course_path(provider_code: course.provider_code, course_code: course.course_code, anchor: 'section-schools'), visible: :hidden)
    end

    it 'renders University' do
      expect(html).to have_css('span.app-description-list__hint.govuk-\\!-padding-top-2', text: 'University')
    end

    it 'renders dt with Location' do
      expect(html).to have_css('dt.app-description-list__label', text: 'Location')
      expect(html).not_to have_css('dt.app-description-list__label', text: 'Nearest location')
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

      it "renders '35 miles from you'" do
        expect(html).to match('35 miles from you')
      end

      it 'renders Placement schools distance summary' do
        expect(html).to have_css('span.govuk-details__summary-text', text: 'Placement schools might be in commuting distance')
      end
    end

    context 'course has two locations' do
      let(:site2) do
        build(
          :site,
          **lat_lon,
          address1: '3 Beech Rd',
          address2: 'Billericay',
          address3: 'Essex',
          address4: 'UK',
          postcode: 'CM12 5YF',
        )
      end

      let(:site_statuses) do
        [
          build(:site_status, :full_time_and_part_time, site: site1),
          build(:site_status, :full_time_and_part_time, site: site2),
        ]
      end

      it "renders '(Nearest of 2 locations to choose from)'" do
        expect(html).to match('(Nearest of 2 locations to choose from)')
      end
    end
  end
end
