class CycleTimetable
  CYCLE_DATES = {
    2021 => {
      find_opens: Time.zone.local(2020, 10, 6, 9),
      apply_opens: Time.zone.local(2020, 10, 13, 9),
      first_deadline_banner: Time.zone.local(2021, 7, 12, 9),
      apply_1_deadline: Time.zone.local(2021, 9, 7, 18),
      apply_2_deadline: Time.zone.local(2021, 9, 21, 18),
      find_closes: Time.zone.local(2021, 10, 3),
    },
    2022 => {
      find_opens: Time.zone.local(2021, 10, 5, 9),
      apply_opens: Time.zone.local(2021, 10, 12, 9),
      # the dates from below here are not the finalised but are required for
      # the current implementation
      first_deadline_banner: Time.zone.local(2022, 7, 12, 9),
      apply_1_deadline: Time.zone.local(2022, 9, 7, 18),
      apply_2_deadline: Time.zone.local(2022, 9, 21, 18),
      find_closes: Time.zone.local(2022, 10, 3),
    },
  }.freeze

  def self.current_year
    now = Time.zone.now

    CYCLE_DATES.keys.detect do |year|
      return year if last_recruitment_cycle_year?(year)

      now.between?(CYCLE_DATES[year][:find_opens], CYCLE_DATES[year + 1][:find_opens])
    end
  end

  def self.next_year
    current_year + 1
  end

  def self.find_closes
    date(:find_closes)
  end

  def self.first_deadline_banner
    date(:first_deadline_banner)
  end

  def self.apply_1_deadline
    date(:apply_1_deadline)
  end

  def self.apply_2_deadline
    date(:apply_2_deadline)
  end

  def self.find_opens
    date(:find_opens, current_year)
  end

  def self.find_reopens
    date(:find_opens, next_year)
  end

  def self.apply_reopens
    date(:apply_opens, next_year)
  end

  def self.preview_mode?
    Time.zone.now.between?(apply_2_deadline, find_closes)
  end

  def self.find_down?
    return false if Time.zone.now > find_opens && Time.zone.now < find_closes

    true
  end

  def self.mid_cycle?
    Time.zone.now.between?(find_opens, apply_2_deadline)
  end

  def self.show_apply_1_deadline_banner?
    Time.zone.now.between?(first_deadline_banner, apply_1_deadline)
  end

  def self.show_apply_2_deadline_banner?
    Time.zone.now.between?(apply_1_deadline, apply_2_deadline)
  end

  def self.show_cycle_closed_banner?
    Time.zone.now.between?(apply_2_deadline, find_closes)
  end

  def self.date(name, year = current_year)
    CYCLE_DATES[year].fetch(name)
  end

  def self.last_recruitment_cycle_year?(year)
    year == CYCLE_DATES.keys.last
  end

  def self.cycle_year_range(year = current_year)
    "#{year} to #{year + 1}"
  end

  def self.current_cycle_schedule
    # Make sure this setting only has effect on non-production environments
    return :real if HostingEnvironment.production?

    SiteSetting.cycle_schedule
  end

  def self.real_schedule_for(year = current_year)
    CYCLE_DATES[year]
  end

  def self.fake_schedules
    {
      today_is_mid_cycle: {
        current_year => {
          find_opens: 7.days.ago,
          apply_opens: 6.days.ago,
          show_deadline_banner: 1.day.ago,
          apply_1_deadline: 1.day.from_now,
          apply_2_deadline: 2.days.from_now,
          find_closes: 3.days.from_now,
        },
        next_year => {
          find_opens: 6.days.from_now,
          apply_opens: 7.days.from_now,
        },
      },
      today_is_after_find_closes: {
        current_year => {
          find_opens: 7.days.ago,
          apply_opens: 6.days.ago,
          show_deadline_banner: 5.days.ago,
          apply_1_deadline: 4.days.ago,
          apply_2_deadline: 2.days.ago,
          find_closes: 1.day.ago,
        },
        next_year => {
          find_opens: 6.days.from_now,
          apply_opens: 7.days.from_now,
        },
      },
      today_is_after_find_opens: {
        current_year => {
          find_opens: 9.days.ago,
          apply_opens: 8.days.from_now,
          show_deadline_banner: 7.days.ago,
          apply_1_deadline: 6.days.ago,
          apply_2_deadline: 5.days.ago,
          find_closes: 4.days.ago,
        },
        next_year => {
          find_opens: 1.day.ago,
          apply_opens: 2.days.from_now,
        },
      },
    }
  end

  private_class_method :last_recruitment_cycle_year?
end
