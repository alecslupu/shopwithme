class Deal < ActiveRecord::Base
  belongs_to :advertiser
  belongs_to :country
  attr_accessible :code, :date_added, :description, :end_date, :start_date, :url
end
