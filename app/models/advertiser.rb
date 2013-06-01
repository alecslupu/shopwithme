class Advertiser < ActiveRecord::Base
  belongs_to :category
  belongs_to :country
  has_many :products, :dependent => :destroy
  has_many :random_products, :class_name => 'RandomAdvertiserProduct', :dependent => :destroy
  has_many :categories, :through => :products
  has_one :advertiser_feed, :dependent => :destroy 

  before_save :fetch_products 
  after_save :enqueue_feed 
  
  attr_accessible :active, :click_through, :description, :enabled, :logo, :metadata_version, :name, :strapline, :url
  extend FriendlyId

  searchable do
    text :name, :boost => 5
    text :description, :strapline
  end

  scope :random, order("RAND()")
  scope :alphabetically, order(:name)
  scope :with_products, where('products_count > 0')
  

  friendly_id :name, use: :slugged
  paginates_per 5

  def compute_random_products(how_many)
    transaction do 
      random_products.clear
      products.random.limit(how_many).each do |product|
        random_products.create(:product => product)
      end
    end
  end

  def to_s 
    name
  end

  def short_title
    name.split(" ").first(5).join(" ")
  end 
  
  def single_url
    url.split(", ").first
  end 

  def self.fetch_by_categories_id(category_ids)
    joins(:categories).group(:id).where(['categories.id IN (?)', category_ids])
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

