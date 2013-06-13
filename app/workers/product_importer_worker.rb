class ProductImporterWorker < ResqueJob
  @queue = :product_feed

  def self.perform

    ProductFastImport.limit(50).each do |a|

      product = Product.where(:aw_product_id => a.aw_product_id).first_or_initialize

      product.merchant_product_id = a.merchant_product_id
      product.name                = a.product_name
      product.description         = a.description
      product.aw_deep_link        = a.aw_deep_link
      product.aw_image_url        = a.aw_image_url
      product.aw_thumb_url        = a.aw_thumb_url
      product.search_price        = a.search_price
      product.display_price       = a.display_price
      product.store_price         = a.store_price
      product.delivery_cost       = a.delivery_cost
      product.currency            = a.currency
      product.valid_to            = a.valid_to
      product.valid_from          = a.valid_from    
      product.stock_quantity      = a.stock_quantity
      product.model_number        = a.model_number
      product.merchant_deep_link  = a.merchant_deep_link
      product.merchant_image_url  = a.merchant_image_url
      product.parent_product_id   = a.parent_product_id
      product.pre_order           = a.pre_order
      product.product_type        = a.product_type
      product.delivery_time       = a.delivery_time
      product.is_for_sale         = a.is_for_sale
      product.in_stock            = a.in_stock
      product.rrp_price           = a.rrp_price
      product.upc                 = a.upc
      product.merchant_thumb_url  = a.merchant_thumb_url
      product.condition           = a.condition
      product.ean                 = a.ean
      product.isbn                = a.isbn
      product.language            = a.language
      product.mpn                 = a.mpn
      product.promotional_text    = a.promotional_text
      product.specifications      = a.specifications
      product.warranty            = a.warranty
      product.web_offer           = a.web_offer
      product.merchant_category   = a.merchant_category
      product.commission_group    = a.commission_group
      product.advertiser          = Rails.cache.fetch("adv_#{a.merchant_id.to_i}", :expires_in => 500.minutes) { Advertiser.where(:id => a.merchant_id.to_i).first }
      product.category            = Rails.cache.fetch("cat_#{a.category_id.to_i}", :expires_in => 500.minutes)   { Category.where(:id => a.category_id.to_i).first }

      if a.brand_id.to_i > 0 
        brand = Brand.where(:id => a.brand_id.to_i).first_or_create do |b|
          b.id   = a.brand_id.to_i
          b.name = a.brand_name
        end
      end 

      product.brand = Rails.cache.fetch("brand_#{a.brand_id.to_i}", :expires_in => 500.minutes)   { Brand.where(:id => a.brand_id.to_i).first }  

      product.save!

      a.destroy
    end

    Resque.enqueue(ProductImporterWorker) if ProductFastImport.count > 0 
  end 
end