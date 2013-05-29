class RandomAdvertiserProduct < ActiveRecord::Base
  belongs_to :advertiser
  belongs_to :product
  attr_accessible :product
end
