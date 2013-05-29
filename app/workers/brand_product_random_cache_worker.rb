class BrandProductRandomCacheWorker < ResqueJob
  @queue = :cache

  def self.perform(brand_id)
    ActiveRecord::Base.verify_active_connections!

    a = Brand.find(brand_id)
    a.compute_random_products(10)

    Resque.remove_delayed(BrandProductRandomCacheWorker, brand_id)
    if a.products_count > 30000
      Resque.enqueue_at(a.products_count.seconds.from_now, BrandProductRandomCacheWorker, brand_id)
    else
      Resque.enqueue_at(4.hours.from_now, BrandProductRandomCacheWorker, brand_id)
    end
  end
  
end

