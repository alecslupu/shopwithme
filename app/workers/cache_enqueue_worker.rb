class CacheEnqueueWorker < ResqueJob
  @queue = :cache

  def self.perform
    ActiveRecord::Base.verify_active_connections!

    enqueue_categories
    enqueue_brands
    enqueue_advertisers
  end 

  protected 
  def enqueue_advertisers
    Advertiser.with_products.each do |a|
      Resque.remove_delayed(AdvertiserProductRandomCacheWorker, a.id)
      if a.products_count > 30000
        Resque.enqueue_at(a.products_count.seconds.from_now, AdvertiserProductRandomCacheWorker, a.id)
      else
        Resque.enqueue_at(4.hours.from_now, AdvertiserProductRandomCacheWorker, a.id)
      end
    end     
  end 

  def enqueue_brands 
    Brand.with_products.each do |b|
      Resque.remove_delayed(BrandProductRandomCacheWorker, b.id)
        if b.products_count > 30000
          Resque.enqueue_at(a.products_count.seconds.from_now, BrandProductRandomCacheWorker, b.id)
        else
          Resque.enqueue_at(4.hours.from_now, BrandProductRandomCacheWorker, b.id)
        end
      end 
    end
  end

  def enqueue_categories
    Category.with_products.each do |c|
      Resque.remove_delayed(CategoryProductRandomCacheWorker, c.id)
      if c.products_count > 30000
        Resque.enqueue_at(a.products_count.seconds.from_now, CategoryProductRandomCacheWorker, c.id)
      else
        Resque.enqueue_at(4.hours.from_now, CategoryProductRandomCacheWorker, c.id)
      end
    end 
  end
end