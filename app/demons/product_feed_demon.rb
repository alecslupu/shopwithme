class ProductFeedDemon < JobUtilsDemon
  # def initialize(args)
  # end

  FIELDS = "merchant_id,merchant_category,merchant_deep_link,merchant_image_url,aw_thumb_url,commission_group,condition,delivery_time,ean,in_stock,isbn,is_for_sale,language,merchant_thumb_url,mpn,parent_product_id,pre_order,product_type,promotional_text,rrp_price,specifications,upc,warranty,web_offer,aw_product_id,merchant_product_id,product_name,display_price,store_price,description,category_id,aw_deep_link,aw_image_url,search_price,currency,delivery_cost,brand_name,brand_id,valid_to,valid_from,stock_quantity,model_number".split(',')
  def process(merchant_id)
    @coder = HTMLEntities.new

    @merchant_id = merchant_id
    get_data
  end
  protected 

  def get_csv_content(obtained_file)
    @advertiser = Advertiser.where(:id => @merchant_id).first

    if File.exists?(obtained_file)
      @header_skipped = false
      lines = []
      IO.foreach(obtained_file) do |line|
        lines << line
        if lines.size >= 100
          lines = CSV.parse(lines.join) rescue next
          store lines
          lines = []
        end
      end 
      store lines
    end
  end
  

  def store(lines)
    lines.each do |row|
      unless @header_skipped 
        @header_skipped = true
        next
      end
      process_feed(row)
    end 
    GC.start
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
    "/datafeed/download/apikey/#{api_key}/mid/#{@merchant_id}/columns/#{FIELDS.join(',')}/format/csv/delimiter/,/compression/zip/"
  end 

  def process_feed(row)
    raise "Advertiser not found #{@merchant_id}" if @advertiser.nil?
    product = Product.where(:aw_product_id => row[FIELDS.index('aw_product_id')].to_i).first_or_initialize
    product.advertiser          = @advertiser
    product.category            = Category.where(:id => row[FIELDS.index('category_id')].to_i).first
    product.merchant_product_id = row[FIELDS.index('merchant_product_id')].to_i
    product.name                = @coder.decode(row[FIELDS.index('product_name')])
    product.description         = @coder.decode(row[FIELDS.index('description')])
    product.aw_deep_link        = @coder.decode(row[FIELDS.index('aw_deep_link')])
    product.aw_image_url        = row[FIELDS.index('aw_image_url')]
    product.aw_thumb_url        = row[FIELDS.index('aw_thumb_url')]
    product.search_price        = row[FIELDS.index('search_price')].to_f
    product.display_price       = row[FIELDS.index('display_price')].to_f
    product.store_price         = row[FIELDS.index('store_price')].to_f
    product.delivery_cost       = row[FIELDS.index('delivery_cost')].to_f
    product.currency            = row[FIELDS.index('currency')]
    product.valid_to            = row[FIELDS.index('valid_to')]
    product.valid_from          = row[FIELDS.index('valid_from')]
    product.stock_quantity      = @coder.decode(row[FIELDS.index('stock_quantity')]).to_i
    product.model_number        = @coder.decode(row[FIELDS.index('model_number')])

    product.merchant_category   = @coder.decode(row[FIELDS.index('merchant_category')])
    product.merchant_deep_link  = row[FIELDS.index('merchant_deep_link')]
    product.merchant_image_url  = row[FIELDS.index('merchant_image_url')]
    product.commission_group    = row[FIELDS.index('commission_group')]
    product.condition           = @coder.decode(row[FIELDS.index('condition')])
    product.delivery_time       = row[FIELDS.index('delivery_time')]
    product.ean                 = @coder.decode(row[FIELDS.index('ean')])
    product.in_stock            = row[FIELDS.index('in_stock')]
    product.isbn                = @coder.decode(row[FIELDS.index('isbn')])
    product.is_for_sale         = row[FIELDS.index('is_for_sale')]
    product.language            = @coder.decode(row[FIELDS.index('language')])
    product.merchant_thumb_url  = row[FIELDS.index('merchant_thumb_url')]
    product.mpn                 = @coder.decode(row[FIELDS.index('mpn')])
    product.parent_product_id   = row[FIELDS.index('parent_product_id')]
    product.pre_order           = row[FIELDS.index('pre_order')]
    product.product_type        = row[FIELDS.index('product_type')]
    product.promotional_text    = @coder.decode(row[FIELDS.index('promotional_text')])
    product.rrp_price           = row[FIELDS.index('rrp_price')]
    product.specifications      = @coder.decode(row[FIELDS.index('specifications')])
    product.upc                 = row[FIELDS.index('upc')]
    product.warranty            = @coder.decode(row[FIELDS.index('warranty')])
    product.web_offer           = @coder.decode(row[FIELDS.index('web_offer')])

    if row[FIELDS.index('brand_id')].to_i > 0 
      brand = Brand.where(:id => row[FIELDS.index('brand_id')].to_i).first_or_create do |b|
        b.id   = row[FIELDS.index('brand_id')].to_i
        b.name = @coder.decode(row[FIELDS.index('brand_name')])
      end
      product.brand = brand  if brand.persisted?
    end 
    product.save!
  end
  
end