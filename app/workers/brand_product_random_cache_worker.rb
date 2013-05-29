class BrandProductRandomCacheWorker < ResqueJob
  @queue = :cache

  def self.perform(brand_id)
    ActiveRecord::Base.verify_active_connections!

    a = Brand.find(brand_id)
    a.compute_random_products(10)

    Resque.remove_delayed(BrandProductRandomCacheWorker, brand_id)
    Resque.enqueue_at(5.hours.from_now, BrandProductRandomCacheWorker, brand_id)
  end
  
end

