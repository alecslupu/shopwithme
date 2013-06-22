class Brand < ActiveRecord::Base
  has_many :products
  has_many :random_products, :class_name => 'RandomBrandProduct', :dependent => :destroy
  after_commit :flush_cache
  attr_accessible :name

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  searchable do
    text :name
  end

  scope :with_products, where('products_count > 0')
  scope :alphabetically, order(:name)
  paginates_per 5

  def to_s 
    name
  end

  def short_title 
    name.split(" ").first(5).join(" ")
  end
  

  def compute_random_products(how_many)
    transaction do 
      random_products.clear
      ActiveRecord::Base.connection().execute("SELECT @v:=RAND() * (SELECT MAX(id) FROM products where brand_id = #{self.id})")
      products.where("id > @v").limit(how_many).each do |product|
        random_products.create(:product => product)
      end
    end
  end

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end

  private 
  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end
end