require 'rails_helper'

describe Course do
  describe '#travel_to_work_areas' do
    context 'when there is a single site' do
      let(:course) do
        build(
          :course,
          site_statuses: [
            build(:site_status, site: build(:site, london_borough: 'Westminster')),
          ],
        )
      end

      it 'returns that site' do
        expect(course.travel_to_work_areas).to eq 'Westminster'
      end
    end

    context 'when there are two travel sites' do
      let(:course) do
        build(
          :course,
          site_statuses: [
            build(:site_status, site: build(:site, london_borough: 'Westminster')),
            build(:site_status, site: build(:site, london_borough: 'Camden')),
          ],
        )
      end

      it 'returns both sites with the correct format' do
        expect(course.travel_to_work_areas).to eq 'Westminster and Camden'
      end
    end

    context 'when there are more than two travel sites' do
      let(:course) do
        build(
          :course,
          site_statuses: [
            build(:site_status, site: build(:site, london_borough: 'Westminster')),
            build(:site_status, site: build(:site, london_borough: 'Camden')),
            build(:site_status, site: build(:site, london_borough: 'Southwark')),
            build(:site_status, site: build(:site, london_borough: 'Islington')),
          ],
        )
      end

      it 'returns all sites with the correct format' do
        expect(course.travel_to_work_areas).to eq 'Westminster, Camden, Southwark and Islington'
      end
    end
  end
end
