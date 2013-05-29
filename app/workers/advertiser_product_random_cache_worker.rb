class AdvertiserProductRandomCacheWorker < ResqueJob
  @queue = :cache

  def self.perform(advertiser_id)
    ActiveRecord::Base.verify_active_connections!

    a = Advertiser.find(advertiser_id)
    a.compute_random_products(10)

    Resque.remove_delayed(AdvertiserProductRandomCacheWorker, advertiser_id)

    if a.products_count > 30000
      Resque.enqueue_at(a.products_count.seconds.from_now, AdvertiserProductRandomCacheWorker, advertiser_id)
    else
      Resque.enqueue_at(4.hours.from_now, AdvertiserProductRandomCacheWorker, advertiser_id)
    end
  end
  
end

