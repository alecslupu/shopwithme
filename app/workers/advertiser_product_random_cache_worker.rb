class AdvertiserProductRandomCacheWorker < ResqueJob
  @queue = :cache

  def self.perform(advertiser_id)
    ActiveRecord::Base.verify_active_connections!

    a = Advertiser.find(advertiser_id)
    a.compute_random_products(10)

    Resque.remove_delayed(AdvertiserProductRandomCacheWorker, advertiser_id)
    Resque.enqueue_at(3.hours.from_now, AdvertiserProductRandomCacheWorker, advertiser_id)
  end
  
end

