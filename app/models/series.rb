class Series < ActiveRecord::Base
  has_many :courses, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :end_date

  scope :upcoming, lambda { where("end_date > ?", Date.today) }

  def self.last_month
    where(end_date: 1.month.ago.beginning_of_month..Date.yesterday)
  end

  def pretty_end_date
    end_date.strftime("%B %e, %Y")
  end
end
