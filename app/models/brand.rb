class Brand < ActiveRecord::Base
  has_many :products

  attr_accessible :name

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :with_products, where('products_count > 0')
  scope :alphabetically, order(:name)
  paginates_per 5

  def to_s 
    name
  end

  def short_title 
    name.split(" ").first(5).join(" ")
  end
  
  # 
  # scope :random, with_products.order("Rand()")
  # scope :ordered, with_products.
end