class Advertiser < ActiveRecord::Base
  belongs_to :category
  belongs_to :country
  has_many :products, :dependent => :destroy
  has_one :advertiser_feed, :dependent => :destroy 

  before_save :fetch_products 
  after_save :enqueue_feed 
  
  attr_accessible :active, :click_through, :description, :enabled, :logo, :metadata_version, :name, :strapline, :url
  extend FriendlyId

  friendly_id :name, use: :slugged

  def to_s 
    name
  end

  def short_title
    name.split(" ").first(5).join(" ")
  end 
  
  def single_url
    url.split(", ").first
  end 

  # scope :enabled, where(:enabled => true)
  # scope :with_products, where('products_count > 0')
  # scope :random, enabled.with_products.order("Rand()")

  # def categories_count
  #   products.where('category_id IS NOT NULL ').group(:category).count.delete_if {|key, value| key.nil? }
  # end

private 
  def fetch_products
    @enqueue = self.enabled? && self.enabled_changed?
  end 

  def enqueue_feed
    if @enqueue == true
      Resque.enqueue(ProductFeedWorker, id)
    end
  end
end

