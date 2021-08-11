require 'rails_helper'

RSpec.describe CycleTimetable do
  let(:one_hour_before_find_opens) { Time.zone.local(2020, 10, 6, 8, 0, 0) }
  let(:one_hour_after_find_opens) { Time.zone.local(2020, 10, 6, 10, 0, 0) }
  let(:one_hour_before_first_deadline_banner) { Time.zone.local(2021, 7, 12, 8, 0, 0) }
  let(:one_hour_before_apply_1_deadline) { Time.zone.local(2021, 8, 24, 17, 0, 0) }
  let(:one_hour_after_apply_1_deadline) { Time.zone.local(2021, 9, 7, 19, 0, 0) }
  let(:one_hour_before_apply_2_deadline) { Time.zone.local(2021, 9, 21, 17, 0, 0) }
  let(:one_hour_after_apply_2_deadline) { Time.zone.local(2021, 9, 21, 19, 0, 0) }
  let(:one_hour_after_find_closes) { Time.zone.local(2021, 10, 4, 1, 0, 0) }
  let(:one_hour_after_find_reopens) { Time.zone.local(2021, 10, 5, 10, 0, 0) }

  describe '.current_year' do
    it 'is 2021 if we are in the middle of the 2021 cycle' do
      Timecop.travel(Time.zone.local(2021, 1, 1, 12, 0, 0)) do
        expect(CycleTimetable.current_year).to eq(2021)
      end
    end

    it 'is 2022 if we are in the middle of the 2022 cycle' do
      Timecop.travel(Time.zone.local(2021, 11, 1, 12, 0, 0)) do
        expect(CycleTimetable.current_year).to eq(2022)
      end
    end
  end

  describe '.next_year' do
    it 'is 2021 if we are in the middle of the 2021 cycle' do
      Timecop.travel(Time.zone.local(2021, 1, 1, 12, 0, 0)) do
        expect(CycleTimetable.next_year).to eq(2022)
      end
    end

    it 'is 2022 if we are in the middle of the 2022 cycle' do
      Timecop.travel(Time.zone.local(2021, 11, 1, 12, 0, 0)) do
        expect(CycleTimetable.next_year).to eq(2023)
      end
    end
  end

  describe '.preview_mode?' do
    it 'returns true when it is after the Apply 2 deadline but before Find closes' do
      Timecop.travel(one_hour_after_apply_2_deadline) do
        expect(CycleTimetable.preview_mode?).to be true
      end
    end

    it 'returns false before the Apply 2 deadline' do
      Timecop.travel(one_hour_before_apply_2_deadline) do
        expect(CycleTimetable.preview_mode?).to be false
      end
    end

    it 'returns false when Find has reopened' do
      Timecop.travel(one_hour_after_find_reopens) do
        expect(CycleTimetable.preview_mode?).to be false
      end
    end
  end

  describe '.find_down?' do
    it 'returns true when it is after Find closes and before it reopens' do
      Timecop.travel(one_hour_after_find_closes) do
        expect(CycleTimetable.find_down?).to be true
      end
    end

    it 'returns false before Find closes' do
      Timecop.travel(one_hour_before_apply_2_deadline) do
        expect(CycleTimetable.find_down?).to be false
      end
    end

    it 'returns false when Find has reopened' do
      Timecop.travel(one_hour_after_find_reopens) do
        expect(CycleTimetable.find_down?).to be false
      end
    end
  end

  describe '.mid_cycle??' do
    it 'returns true after Find has opened' do
      Timecop.travel(one_hour_after_find_opens) do
        expect(CycleTimetable.mid_cycle?).to be true
      end
    end

    it 'returns false after the apply_2_deadline' do
      Timecop.travel(one_hour_after_apply_2_deadline) do
        expect(CycleTimetable.mid_cycle?).to be false
      end
    end

    context 'when current_cycle_schedule returns `:today_is_after_find_opens`' do
      it 'returns true' do
        allow(CycleTimetable).to receive(:current_cycle_schedule).and_return(:today_is_after_find_opens)
        expect(CycleTimetable.mid_cycle?).to be true
      end
    end
  end

  describe '.show_apply_1_deadline_banner?' do
    it 'returns true when it is after the deadline_banner and before the apply_1_deadline' do
      Timecop.travel(one_hour_before_apply_1_deadline) do
        expect(CycleTimetable.show_apply_1_deadline_banner?).to be true
      end
    end

    it 'returns false after the the apply_1_deadline' do
      Timecop.travel(one_hour_after_apply_1_deadline) do
        expect(CycleTimetable.show_apply_1_deadline_banner?).to be false
      end
    end

    it 'returns false before the deadline_banner' do
      Timecop.travel(one_hour_before_first_deadline_banner) do
        expect(CycleTimetable.show_apply_1_deadline_banner?).to be false
      end
    end
  end

  describe '.show_apply_2_deadline_banner?' do
    it 'returns true when it is after the apply_1_deadline and before the apply_2_deadline' do
      Timecop.travel(one_hour_before_apply_2_deadline) do
        expect(CycleTimetable.show_apply_2_deadline_banner?).to be true
      end
    end

    it 'returns false before the after the apply_2_deadline' do
      Timecop.travel(one_hour_after_apply_2_deadline) do
        expect(CycleTimetable.show_apply_2_deadline_banner?).to be false
      end
    end

    it 'returns false before the apply_1_deadline' do
      Timecop.travel(one_hour_before_apply_1_deadline) do
        expect(CycleTimetable.show_apply_2_deadline_banner?).to be false
      end
    end
  end

  describe '.show_cycle_closed_banner?' do
    it 'returns true when it is after the apply_2_deadline and before Find closes' do
      Timecop.travel(one_hour_after_apply_2_deadline) do
        expect(CycleTimetable.show_cycle_closed_banner?).to be true
      end
    end

    it 'returns false after Find closes' do
      Timecop.travel(one_hour_after_find_closes) do
        expect(CycleTimetable.show_cycle_closed_banner?).to be false
      end
    end

    it 'returns false before the apply_2_deadline' do
      Timecop.travel(one_hour_before_apply_2_deadline) do
        expect(CycleTimetable.show_cycle_closed_banner?).to be false
      end
    end
  end
end
