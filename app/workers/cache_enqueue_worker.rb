class CacheEnqueueWorker < ResqueJob
  @queue = :cache

  def self.perform
    ActiveRecord::Base.verify_active_connections!

    Advertiser.with_products.each do |a|
      a.compute_random_products(20)
    end
    Brand.with_products.each do |b|
      b.compute_random_products(20)
    end
    Category.with_products.each do |c|
      c.compute_random_products(20)
    end 

    Resque.remove_delayed(CacheEnqueueWorker)
    Resque.enqueue_at(12.hours.from_now, CacheEnqueueWorker)
  end 
end