class Product < ActiveRecord::Base
  belongs_to :advertiser, :counter_cache => true
  belongs_to :category
  belongs_to :brand, :counter_cache => true
  attr_accessible :aw_deep_link, :aw_image_url, :aw_product_id, :aw_thumb_url, :currency, :delivery_cost, :description, :merchant_product_id, :model_number, :name, :search_price, :stock_quantity, :valid_from, :valid_to
  
  extend FriendlyId

  friendly_id :name, use: :slugged
  paginates_per 10

  scope :random, order("RAND()")

  def product_by_advertiser
    advertiser.products.where('id <> ?', id).random.limit(3)
  end
end
