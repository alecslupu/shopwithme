class RandomCategoryProduct < ActiveRecord::Base
  belongs_to :category
  belongs_to :product
  attr_accessible :product
end
