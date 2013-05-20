class Advertiser < ActiveRecord::Base
  belongs_to :category
  belongs_to :country
  has_many :products, :dependent => :destroy
  has_one :advertiser_feed, :dependent => :destroy 

  
  attr_accessible :active, :click_through, :description, :enabled, :logo, :metadata_version, :name, :strapline, :url
  extend FriendlyId

  friendly_id :name, use: :slugged

  scope :enabled, where(:enabled => true)
  scope :with_products, where('products_count > 0')
  scope :random, enabled.with_products.order("Rand()")

  def to_s 
    name
  end

  def categories_count
    products.where('category_id IS NOT NULL ').group(:category).count.delete_if {|key, value| key.nil? }
  end

end

