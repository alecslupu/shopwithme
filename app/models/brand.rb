class Brand < ActiveRecord::Base
  has_many :products
  has_many :random_products, :class_name => 'RandomBrandProduct', :dependent => :destroy
  after_commit :flush_cache
  attr_accessible :name

  extend FriendlyId
  friendly_id :name, use: :slugged

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
      products.random.limit(how_many).each do |product|
        random_products.create(:product => product)
      end
    end
  end

=begin 
def approved_banner_embed_random conditions
    return Rails.cache.fetch("approved_ba_4erand_#{self.unique_code}_#{ShaSignature.secure_digest conditions.to_s}", :expires_in => 60.minutes.to_i) do
      ActiveRecord::Base.connection().execute("SELECT @v:=RAND() * (SELECT MAX(id) FROM banners)")
      owncampaigns = get_cached_member_in_campaigns_campaign_ids(conditions)
      unless owncampaigns.size.zero?
        conditions<< "campaign_id IN (#{owncampaigns.join(',')})"
      end
      conditions<< "id > @v"
      Banner.where(conditions.reverse.join(" AND ")).includes(:banner_picture, :campaign).order("id").first
    end
  end
=end

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end

  private 
  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end
end