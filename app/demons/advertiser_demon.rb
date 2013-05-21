class AdvertiserDemon < JobUtilsDemon
  # def initialize(args)  
  # end
  
  def process 
    process_advertisers(get_data)
  end 
  
  private 

  def feed_deflated 
    @deflated_name ||= "#{Time.now.to_i.to_s}_advertisers.csv"
  end

  def feed_archive
    @archive_name ||= "#{Time.now.to_i.to_s}_advertisers.zip"
  end 

  def domain 
    "www.affiliatewindow.com"
  end 

  def feed_url 
    "/affiliates/shopwindow/datafeed_metadata.php?user=#{user_id}&password=#{user_password}&format=CSV&filter=ALL_ALL&compression=zip"
  end 

  def process_advertisers(elements)

    elements.each_with_index do |row, index|

      advertiser = Advertiser.where(:id => row["Merchant ID"].to_i).first_or_initialize 

      advertiser.name             = row["Merchant Name"]
      advertiser.logo             = row["Logo"]
      advertiser.active           = (row["Active"].downcase == "yes")
      advertiser.metadata_version = row["Merchant Metadata Version"].to_i
      advertiser.strapline        = row["Strapline"]
      advertiser.description      = row["Description"]

      advertiser.category = Category.where(:name => row["Merchant Category"]).first
      advertiser.country = Country.where(:country_code => row["Primary Region"]).first

      advertiser.url = row["Display URL"]
      advertiser.click_through = row["Default Clickthrough"]
      advertiser.enabled = (row["Default Clickthrough"] != "You are not joined to this merchant")

      enabled = advertiser.enabled_changed?
      advertiser.save

      if advertiser.persisted? 
        if (row["Product Feed Enabled"].downcase == "yes")
          feed = AdvertiserFeed.where(:advertiser_id => advertiser.id).first_or_initialize do |af|
            af.feed_version = row["Datafeed Version"] 
            af.feed_last_refresh = row["Product Feed Last Refreshed"]
            af.feed_last_modified = row["Product Feed Last Modified"]
            af.feed_product_count = row["Product Feed No. Products"].to_i
          end

          if (@enabled or feed.feed_last_modified_changed?)
            Resque.enqueue(ProductFeedWorker, advertiser.id)
          end
          feed.save
        end
      end
    end
  end
end