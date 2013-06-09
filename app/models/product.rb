class Product < ActiveRecord::Base
  belongs_to :advertiser, :counter_cache => true
  belongs_to :category, :counter_cache => true
  belongs_to :brand, :counter_cache => true
  has_many :visit_logs, :class_name => 'ProductVisitLog',:dependent => :destroy
  has_many :display_logs, :class_name => 'ProductDisplayLog',:dependent => :destroy



  attr_accessible :aw_deep_link, :aw_image_url, :aw_product_id, :aw_thumb_url, :currency, :delivery_cost, :description, :merchant_product_id, :model_number, :name, :search_price, :stock_quantity, :valid_from, :valid_to, :merchant_category, :merchant_deep_link, :merchant_image_url, :commission_group, :condition, :delivery_time, :ean,:in_stock,:isbn,:is_for_sale,:language,:merchant_thumb_url,:mpn, :pre_order, :product_type, :promotional_text, :upc,:warranty,:parent_product_id, :rrp_price, :web_offer, :specifications
  after_commit :flush_cache

  extend FriendlyId

  friendly_id :name, use: :slugged

  searchable do
    text :name, :boost => 5, :more_like_this => true
    text :description
  end
  
  paginates_per 15

  scope :random, order("RAND()")
  scope :include_all, includes(:advertiser, :category)
  
  scope :page_with_cached_total_count, lambda {|page_number, total_count|
    order("id").page(page_number).extending {
      # open scope to smuggle total_count
      define_method(:total_count) { @total_count = total_count }
    }
  }

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end

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

  private 
  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end
end
