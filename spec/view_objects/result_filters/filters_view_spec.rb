require 'rails_helper'

module ResultFilters
  describe FiltersView do
    describe '#qts_only_checked?' do
      subject { described_class.new(params: params).qts_only_checked? }

      context 'when QtsOnly param not present' do
        let(:params) { { qualifications: %w[Other PgdePgceWithQts] } }

        it { is_expected.to eq(false) }
      end

      context 'when QtsOnly param is present' do
        let(:params) { { qualifications: %w[QtsOnly PgdePgceWithQts] } }

        it { is_expected.to eq(true) }
      end

      context 'when qualifications is empty' do
        let(:params) { { qualifications: [] } }

        it { is_expected.to eq(false) }
      end

      context 'when parameters are empty' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#pgde_pgce_with_qts_checked' do
      subject { described_class.new(params: params).pgde_pgce_with_qts_checked? }

      context 'when PgdePgceWithQts param not present' do
        let(:params) { { qualifications: %w[Other QtsOnly] } }

        it { is_expected.to eq(false) }
      end

      context 'when PgdePgceWithQts param is present' do
        let(:params) { { qualifications: %w[QtsOnly PgdePgceWithQts] } }

        it { is_expected.to eq(true) }
      end

      context 'when qualifications is empty' do
        let(:params) { { qualifications: [] } }

        it { is_expected.to eq(false) }
      end

      context 'when parameters are empty' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#other_checked?' do
      subject { described_class.new(params: params).other_checked? }

      context 'when Other param not present' do
        let(:params) { { qualifications: %w[QtsOnly PgdePgceWithQts] } }

        it { is_expected.to eq(false) }
      end

      context 'when Other param is present' do
        let(:params) { { qualifications: %w[QtsOnly Other] } }

        it { is_expected.to eq(true) }
      end

      context 'when qualifications is empty' do
        let(:params) { { qualifications: [] } }

        it { is_expected.to eq(false) }
      end

      context 'when parameters are empty' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#qualification_selected?' do
      subject { described_class.new(params: params).qualification_selected? }

      context 'when a parameter is selected' do
        let(:params) { { qualifications: %w[Other] } }

        it { is_expected.to eq(true) }
      end

      context 'when multiple parameters are selected' do
        let(:params) { { qualifications: %w[Other QtsOnly] } }

        it { is_expected.to eq(true) }
      end

      context 'when no parameter is selected' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#location_query?' do
      subject { described_class.new(params: params).location_query? }

      context 'when parameter is present' do
        let(:params) { { l: '1' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#across_england_query?' do
      subject { described_class.new(params: params).across_england_query? }

      context 'when parameter is present' do
        let(:params) { { l: '2' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#provider_query?' do
      subject { described_class.new(params: params).provider_query? }

      context 'when parameter is present' do
        let(:params) { { l: '3' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#funding_checked?' do
      subject { described_class.new(params: params).funding_checked? }

      context 'when parameter is present' do
        let(:params) { { funding: '8' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#send_checked?' do
      subject { described_class.new(params: params).send_checked? }

      context 'when parameter is present' do
        let(:params) { { senCourses: 'true' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#has_vacancies_checked?' do
      subject { described_class.new(params: params).has_vacancies_checked? }

      context 'when parameter is present' do
        let(:params) { { hasvacancies: 'true' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#full_time_checked?' do
      subject { described_class.new(params: params).full_time_checked? }

      context 'when parameter is present' do
        let(:params) { { fulltime: 'true' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#part_time_checked?' do
      subject { described_class.new(params: params).part_time_checked? }

      context 'when parameter is present' do
        let(:params) { { parttime: 'true' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#default_study_types_to_true' do
      subject { described_class.new(params: params).default_study_types_to_true }

      context 'when parameters are not present' do
        let(:params) { {} }

        it { is_expected.to eq(true) }
      end

      context 'when parameters are present' do
        let(:params) do
          {
            parttime: 'true',
            fulltime: 'false',
          }
        end

        it { is_expected.to eq(false) }
      end
    end

    describe '#all_courses_radio_chosen?' do
      subject { described_class.new(params: params).all_courses_radio_chosen? }

      context 'when parameter is present' do
        let(:params) { { degree_required: '1' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#two_two_radio_chosen?' do
      subject { described_class.new(params: params).two_two_radio_chosen? }

      context 'when parameter is present' do
        let(:params) { { degree_required: '2' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#third_class_radio_chosen?' do
      subject { described_class.new(params: params).third_class_radio_chosen? }

      context 'when parameter is present' do
        let(:params) { { degree_required: '3' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#any_degree_grade_radio_chosen?' do
      subject { described_class.new(params: params).any_degree_grade_radio_chosen? }

      context 'when parameter is present' do
        let(:params) { { degree_required: '4' } }

        it { is_expected.to eq(true) }
      end

      context 'when parameter is not present' do
        let(:params) { {} }

        it { is_expected.to eq(false) }
      end
    end

    describe '#default_all_courses_radio_to_true' do
      subject { described_class.new(params: params).default_all_courses_radio_to_true }

      context 'when parameters are not present' do
        let(:params) { {} }

        it { is_expected.to eq(true) }
      end

      context 'when parameters are present' do
        let(:params) do
          {
            degree_required: '2',
          }
        end

        it { is_expected.to eq(false) }
      end
    end
  end
end
