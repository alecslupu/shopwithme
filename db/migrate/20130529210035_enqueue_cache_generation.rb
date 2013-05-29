class EnqueueCacheGeneration < ActiveRecord::Migration
  def up
    Category.with_products.each do |c|
      c.compute_random_products(10)
      Resque.enqueue_at(4.hours.from_now,CategoryProductRandomCacheWorker, c.id)
    end 
    Brand.with_products.each do |c|
      c.compute_random_products(10)
      Resque.enqueue_at(5.hours.from_now,BrandProductRandomCacheWorker, c.id)
    end 
    Advertiser.with_products.each do |c|
      c.compute_random_products(10)
      Resque.enqueue_at(3.hours.from_now,AdvertiserProductRandomCacheWorker, c.id)
    end 
  end

  def down
  end
end
