class ProductSlugWorker < ResqueJob
  @queue = :product_feed

  def self.perform(product_id)
    ActiveRecord::Base.verify_active_connections!

    p = Product.find(product_id)
    p.save
    name = p.name
    name = name.gsub('&quot;', '"')
    name = name.gsub('&quot', '"')
    name = name.gsub('&amp;', '&')
    name = name.gsub('&amp', '&')
    p.name = name
    p.save
  end 
end