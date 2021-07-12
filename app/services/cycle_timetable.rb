class CycleTimetable
  CYCLE_DATES = {
    2021 => {
      find_opens: DateTime.new(2020, 10, 6, 9),
      apply_opens: DateTime.new(2020, 10, 13, 9),
      first_deadline_banner: DateTime.new(2021, 7, 12, 9),
      apply_1_deadline: DateTime.new(2021, 9, 7, 18),
      apply_2_deadline: DateTime.new(2021, 9, 20, 18),
      find_closes: DateTime.new(2021, 10, 3),
    },
    2022 => {
      find_opens: DateTime.new(2021, 10, 5, 9),
      apply_opens: DateTime.new(2021, 10, 12, 9),
      # the dates from below here are not the finalised but are required for
      # the current implementation
      first_deadline_banner: DateTime.new(2022, 7, 12, 9),
      apply_1_deadline: DateTime.new(2021, 9, 7, 18),
      apply_2_deadline: DateTime.new(2022, 9, 20, 18),
      find_closes: DateTime.new(2022, 10, 3),
    },
  }.freeze

  def self.current_year
    now = DateTime.now

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

  private_class_method :last_recruitment_cycle_year?
end
