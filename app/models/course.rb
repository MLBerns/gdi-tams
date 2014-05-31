class Course < ActiveRecord::Base
  before_save :add_dates

  belongs_to :series
  has_many :hours, dependent: :destroy
  has_many :teaching_assistants, through: :hours

  validates_presence_of :credit_hours
  validates_presence_of :num_tas_needed

  scope :upcoming, -> { where("date > ?", Date.today) }
  scope :single_day, -> { where("series_id IS NULL") }
  scope :series, -> { where("series_id > ?", 0) }

  def self.last_month
    where(date: 1.month.ago.beginning_of_month..Date.today)
  end

  def tas
    hours.select { |h| h.is_credit? }.map { |h| h.teaching_assistant }
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
    num_tas_needed - teaching_assistants.count
  end

  def pretty_date_short
    date.strftime("%B %e, %Y")
  end

  private
  def add_dates
    self.pretty_date = self.date.strftime("%B %e, %Y (%A)")
    self.pretty_time = "#{self.start_time.strftime("%I:%M %p")}–#{self.end_time.strftime("%I:%M %p")}"
  end
end
