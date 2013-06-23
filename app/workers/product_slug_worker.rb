class ProductSlugWorker < ResqueJob
  @queue = :product_feed

  def self.perform(product_id)
    ActiveRecord::Base.verify_active_connections!

    Product.where('id >= ?', product_id).first(250).each do |p|
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
end