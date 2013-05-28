class Category < ActiveRecord::Base
  attr_accessible :name, :is_adult, :description #:depth, :lft, , :parent_id, :rgt
  has_many :products
  has_many :advertisers, :through => :products
  
  extend FriendlyId

  friendly_id :name, use: :slugged
  acts_as_nested_set
  rails_admin do
    nested_set({
      max_depth: 3
    })
  end

  paginates_per 5

  scope :random, order("RAND()")
  scope :with_products, where('products_count > 0')
  scope :alphabetically, order('name')
  scope :no_adult, where(:is_adult => 0)
  scope :for_homepage, lambda { |limit| random.no_adult.with_products.limit(limit) }

  def fetch_advertisers
    advertisers.group(:id)
  end 

  def to_s
    name
  end

  def short_title 
    name.split(" ").first(5).join(" ")
  end 
end
