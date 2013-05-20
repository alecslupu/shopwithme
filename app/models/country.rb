class Country < ActiveRecord::Base
  has_many :advertisers 
  
  attr_accessible :country_code, :name

  extend FriendlyId

  friendly_id :name, use: :slugged
end