class RandomBrandProduct < ActiveRecord::Base
  belongs_to :brand
  belongs_to :product
  attr_accessible :product
end
