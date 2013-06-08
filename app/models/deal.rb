class Deal < ActiveRecord::Base
  belongs_to :advertiser
  belongs_to :country
  attr_accessible :code, :date_added, :description, :end_date, :start_date, :url

  scope :active, where('start_date < ? AND end_date > ?', Time.now, Time.now)

  def has_code?
    not ['n/a', 'N/A'].include?(self.code) and not self.code.blank?
  end
end
