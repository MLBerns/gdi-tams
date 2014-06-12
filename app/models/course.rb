class Course < ActiveRecord::Base
  before_validation :format_pretty_dates

  belongs_to :series
  has_many :hours, dependent: :destroy
  has_many :teaching_assistants, through: :hours

  validates_presence_of :credit_hours, :num_tas_needed, :name, :date, :url, :location, :meetup_id, :start_time, :end_time, :pretty_time, :pretty_date

  scope :upcoming, -> { where("date > ?", Date.tomorrow) }
  scope :single_day, -> { where("series_id IS NULL") }
  scope :series, -> { where("series_id > ?", 0) }

  def self.last_month
    where(date: 1.month.ago.beginning_of_month..Date.today)
  end

  def tas
    teaching_assistants.select { |ta| ta.is_ta_for?(self) }
  end

  def hour_for(teaching_assistant)
    hours.where(teaching_assistant: teaching_assistant).first
  end

  def is_series?
    series.present?
  end

  def need_tas?
    num_tas_still_needed > 0
  end

  def num_tas_still_needed
    need = num_tas_needed - teaching_assistants.count
    return 0 if need < 0
    need
  end

  def pretty_date_short
    date.strftime("%B %e, %Y")
  end

  def can_email?
    teaching_assistants.any? && date < 10.days.from_now && date > Date.tomorrow
  end

  private
  def format_pretty_dates
    self.pretty_date = self.date.strftime("%B %e, %Y (%A)")
    self.pretty_time = "#{self.start_time.strftime("%I:%M %p")}–#{self.end_time.strftime("%I:%M %p")}"
  end
end
