class Brand < ActiveRecord::Base
  has_many :products

  attr_accessible :name

  extend FriendlyId

  friendly_id :name, use: :slugged
  scope :with_products, where('products_count > 0')
  scope :random, with_products.order("Rand()")
  scope :ordered, with_products.order(:name)


  def to_s 
    name
  end
end