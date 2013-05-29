class Brand < ActiveRecord::Base
  has_many :products
  has_many :random_products, :class_name => 'RandomBrandProduct', :dependent => :destroy

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
  

  def compute_random_products(how_many)
    transaction do 
      random_products.clear
      products.random.limit(how_many).each do |product|
        random_products.create(:product => product)
      end
    end
  end

  # 
  # scope :random, with_products.order("Rand()")
  # scope :ordered, with_products.
end