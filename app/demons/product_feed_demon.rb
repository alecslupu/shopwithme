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
          lines = CSV.parse(lines.join)
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
    
    ProductFastImport.create!({
      :merchant_product_id => row[FIELDS.index('merchant_product_id')].to_i,
      :description => @coder.decode(row[FIELDS.index('description')]), 
      :category_id => row[FIELDS.index('category_id')].to_i, 
      :aw_product_id => row[FIELDS.index('aw_product_id')].to_i,  
      :product_name => @coder.decode(row[FIELDS.index('product_name')]), 
      :aw_deep_link => @coder.decode(row[FIELDS.index('aw_deep_link')]),
      :stock_quantity => row[FIELDS.index('stock_quantity')].to_i, 
      :model_number => @coder.decode(row[FIELDS.index('model_number')]),
      :currency => row[FIELDS.index('currency')],
      :valid_to => row[FIELDS.index('valid_to')],
      :valid_from => row[FIELDS.index('valid_from')],
      :brand_name => @coder.decode(row[FIELDS.index('brand_name')]),
      :aw_thumb_url => row[FIELDS.index('aw_thumb_url')],
      :display_price => row[FIELDS.index('display_price')].to_f, 
      :store_price => row[FIELDS.index('store_price')].to_f, 
      :aw_image_url => row[FIELDS.index('aw_image_url')], 
      :search_price => row[FIELDS.index('search_price')].to_f,
      :delivery_cost => row[FIELDS.index('delivery_cost')].to_f,
      :commission_group => row[FIELDS.index('commission_group')],
      :merchant_category => @coder.decode(row[FIELDS.index('merchant_category')]),
      :merchant_deep_link => row[FIELDS.index('merchant_deep_link')],
      :merchant_image_url => row[FIELDS.index('merchant_image_url')],
      :condition => @coder.decode(row[FIELDS.index('condition')]), 
      :delivery_time => row[FIELDS.index('delivery_time')],
      :ean => @coder.decode(row[FIELDS.index('ean')]),
      :in_stock => row[FIELDS.index('in_stock')], 
      :isbn => @coder.decode(row[FIELDS.index('isbn')]),
      :is_for_sale => row[FIELDS.index('is_for_sale')],
      :language => @coder.decode(row[FIELDS.index('language')]), 
      :merchant_thumb_url => row[FIELDS.index('merchant_thumb_url')],
      :mpn => @coder.decode(row[FIELDS.index('mpn')]), 
      :parent_product_id => row[FIELDS.index('parent_product_id')],
      :pre_order => row[FIELDS.index('pre_order')],
      :product_type => row[FIELDS.index('product_type')], 
      :promotional_text => @coder.decode(row[FIELDS.index('promotional_text')]),
      :rrp_price => row[FIELDS.index('rrp_price')], 
      :specifications => @coder.decode(row[FIELDS.index('specifications')]), 
      :upc => @coder.decode(row[FIELDS.index('upc')]), 
      :warranty => @coder.decode(row[FIELDS.index('warranty')]),
      :web_offer => @coder.decode(row[FIELDS.index('web_offer')]),
      :merchant_id => @advertiser.id,
      :brand_id => row[FIELDS.index('brand_id')].to_i,  
    })
  end
  
end