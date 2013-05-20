class Category < ActiveRecord::Base
  attr_accessible :name, :is_adult, :description #:depth, :lft, , :parent_id, :rgt
  has_many :products
  has_many :advertisers
  
  extend FriendlyId

  friendly_id :name, use: :slugged
  acts_as_nested_set
  rails_admin do
    nested_set({
      max_depth: 3
    })
  end


  def to_s
    name
  end
end
