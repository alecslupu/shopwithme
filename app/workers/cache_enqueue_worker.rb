class CacheEnqueueWorker < ResqueJob
  @queue = :cache

  def self.perform
    ActiveRecord::Base.verify_active_connections!

    Category.with_products.each do |c|
      Resque.enqueue(CategoryProductRandomCacheWorker, c.id)
    end 
    Brand.with_products.each do |c|
      Resque.enqueue(BrandProductRandomCacheWorker, c.id)
    end 
    Advertiser.with_products.each do |c|
      Resque.enqueue(AdvertiserProductRandomCacheWorker, c.id)
    end 
  end 
end