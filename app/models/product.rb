class Product < ActiveRecord::Base
  belongs_to :advertiser, :counter_cache => true
  belongs_to :category, :counter_cache => true
  belongs_to :brand, :counter_cache => true
  attr_accessible :aw_deep_link, :aw_image_url, :aw_product_id, :aw_thumb_url, :currency, :delivery_cost, :description, :merchant_product_id, :model_number, :name, :search_price, :stock_quantity, :valid_from, :valid_to, :merchant_category, :merchant_deep_link, :merchant_image_url, :commission_group, :condition, :delivery_time, :ean,:in_stock,:isbn,:is_for_sale,:language,:merchant_thumb_url,:mpn, :pre_order, :product_type, :promotional_text, :upc,:warranty,:parent_product_id, :rrp_price, :web_offer, :specifications

  extend FriendlyId

  friendly_id :name, use: :slugged
  paginates_per 10

  scope :random, order("RAND()")

  def to_s 
    name
  end

  def newer?
    created_at > 5.days.ago
  end

  def short_description(how_many = 5)
    if description.present? and @short_description.nil? 
      @short_description = description.split(" ").first(how_many).join(" ")
    end
    @short_description ||= ""
  end

  def short_title 
    name.split(" ").first(5).join(" ")
  end

  def price 
    display_price || store_price || search_price 
  end 

  # def product_by_advertiser
  #   advertiser.products.where('id <> ?', id).random.limit(3)
  # end
end
