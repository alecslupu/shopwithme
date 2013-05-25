class ProductFeedDemon < JobUtilsDemon
  # def initialize(args)
  # end

  def process(merchant_id)
    @merchant_id = merchant_id
    process_categories(get_data)
  end
  
  private 

  def api_key
    "5592ec80ef62df2aea47beca41544df4"
  end

  def feed_deflated 
    @deflated_name ||= "#{Time.now.to_i.to_s}_#{@merchant_id}_product_feed.csv"
  end

  def feed_archive
    @archive_name ||= "#{Time.now.to_i.to_s}_#{@merchant_id}_product_feed.zip"
  end 

  def domain 
    "datafeed.api.productserve.com"
  end 

  def feed_url 
    "/datafeed/download/apikey/#{api_key}/mid/#{@merchant_id}/columns/merchant_id,merchant_category,merchant_deep_link,merchant_image_url,aw_thumb_url,commission_group,condition,delivery_time,ean,in_stock,isbn,is_for_sale,language,merchant_thumb_url,mpn,parent_product_id,pre_order,product_type,promotional_text,rrp_price,specifications,upc,warranty,web_offer,aw_product_id,merchant_product_id,product_name,display_price,description,category_id,aw_deep_link,aw_image_url,search_price,currency,delivery_cost,brand_name,brand_id,valid_to,valid_from,stock_quantity,aw_thumb_url,model_number/format/csv/delimiter/,/compression/zip/"
  end 

  def process_categories(elements)

    advertiser = Advertiser.where(:id => @merchant_id).first

    raise "Advertiser not found #{@merchant_id}" if advertiser.nil?
    elements.each do |row|

      product = Product.where(:aw_product_id => row['aw_product_id'].to_i).first_or_initialize
      product.advertiser          = advertiser
      product.category            = Category.where(:id => row['category_id'].to_i).first
      product.merchant_product_id = row['merchant_product_id'].to_i
      product.name                = row['product_name']
      product.description         = row['description']
      product.aw_deep_link        = row['aw_deep_link']
      product.aw_image_url        = row['aw_image_url']
      product.aw_thumb_url        = row['aw_thumb_url']
      product.search_price        = row['search_price'].to_f
      product.display_price       = row['display_price'].to_f
      product.store_price         = row['store_price'].to_f
      product.delivery_cost       = row['delivery_cost'].to_f
      product.currency            = row['currency']
      product.valid_to            = row['valid_to']
      product.valid_from          = row['valid_from']
      product.stock_quantity      = row['stock_quantity'].to_i
      product.model_number        = row['model_number']








      product.merchant_category   = row['merchant_category']
      product.merchant_deep_link  = row['merchant_deep_link']
      product.merchant_image_url  = row['merchant_image_url']
      product.aw_thumb_url        = row['aw_thumb_url']
      product.commission_group    = row['commission_group']
      product.condition           = row['condition']
      product.delivery_time       = row['delivery_time']
      product.ean                 = row['ean']
      product.in_stock            = row['in_stock']
      product.isbn                = row['isbn']
      product.is_for_sale         = row['is_for_sale']
      product.language            = row['language']
      product.merchant_thumb_url  = row['merchant_thumb_url']
      product.mpn                 = row['mpn'] 
      product.parent_product_id   = row['parent_product_id']
      product.pre_order           = row['pre_order']
      product.product_type        = row['product_type']
      product.promotional_text    = row['promotional_text']
      product.rrp_price           = row['rrp_price']
      product.specifications      = row['specifications']
      product.upc                 = row['upc']
      product.warranty            = row['warranty']
      product.web_offer           = row['web_offer']

      if row['brand_id'].to_i > 0 
        brand = Brand.where(:id => row['brand_id'].to_i).first_or_create do |b|
          b.id   = row['brand_id'].to_i
          b.name = row['brand_name']
        end
        product.brand = brand  if brand.persisted?
      end 
      product.save!
    end
  end
  
end