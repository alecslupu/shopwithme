class SitemapWorker < ResqueJob
  @queue = :sitemap
  
  def self.perform
    ActiveRecord::Base.verify_active_connections!

    SitemapGenerator::Sitemap.default_host = 'http://www.shop-with.me/'
    SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

    SitemapGenerator::Sitemap.create do
      # Shall we add categories ?
      Category.find_in_batches(:batch_size => 100) do |batch|
        batch.each do |category|
          add category_path(category), lastmod: category.updated_at
        end
      end

      Category.page(1).num_pages.times do |index|
        add "#{categories_path}/page/#{index}" #, :changefreq => 'daily', :priority => 0.9
      end

      # Shall we add brands 
      Brand.all.each do |brand|
        add brand_path(brand), lastmod: brand.updated_at
      end 

      # Brand.page(1).num_pages.times do |index|
      #   add "#{brands_path}/page/#{index}", :changefreq => 'daily', :priority => 0.9
      # end 


      # Shall we add Merchants 
      Advertiser.find_in_batches(:batch_size => 100) do |batch|
        batch.each do |advertiser|
          add advertiser_path(advertiser), lastmod: advertiser.updated_at
        end
      end 

      Advertiser.page(1).num_pages.times do |index|
        add "#{advertisers_path}/page/#{index}" #, :changefreq => 'daily', :priority => 0.9
      end 


      # Shall we add Merchants 
      Product.find_in_batches(:batch_size => 100) do |batch|
        batch.each do |product|
          add product_path(product), lastmod: product.updated_at
        end
      end

      Product.page(1).num_pages.times do |index|
        add "#{products_path}/page/#{index}"#, :changefreq => 'daily', :priority => 0.9
      end 

    end
    
    SitemapGenerator::Sitemap.ping_search_engines

  end 
  
end