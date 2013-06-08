class DealDemon < JobUtilsDemon

  def process 
    get_data
  end 
  
  protected
  def feed_deflated 
    @deflated_name ||= "#{Time.now.to_i.to_s}_deals.csv"
  end

  def user_id
    "176745"
  end 

  def password
    "5a24d262243933031a9452fbe33cfa37"
  end

  def domain 
    "www.affiliatewindow.com"
  end 

  def feed_url
    "/affiliates/discount_vouchers.php?user=#{user_id}&password=#{password}&export=csv&voucherSearch=1&rel=1"
  end


  def get_csv_content(obtained_file)
    Deal.destroy_all
    if File.exists?(obtained_file)
      CSV.foreach(obtained_file, :headers => true, :encoding => 'ISO-8859-1') do |row|
        deal = Deal.new 
        deal.advertiser = Advertiser.where(:id => row['merchant_id']).first
        deal.country = Country.where(:country_code => row["region"]).first
        deal.code = row["code"]
        deal.description = row["description"]
        deal.url = row["url"]
        deal.start_date = row["start_date"]
        deal.end_date = row["end_date"]
        deal.date_added = row["Date_Added"]
        deal.save
      end
    end
  end

  def get_data
    path_to_save = Rails.root.join('tmp', 'aw')
    obtained_file = path_to_save.join(feed_deflated)

    download(domain, feed_url, path_to_save, feed_deflated)

    get_csv_content(obtained_file)
    
    File.delete(obtained_file)
  end 

end