class CategoryProductRandomCacheWorker < ResqueJob
  @queue = :cache

  def self.perform(category_id)
    ActiveRecord::Base.verify_active_connections!

    a = Category.find(category_id)
    a.compute_random_products(10)

    Resque.remove_delayed(CategoryProductRandomCacheWorker, category_id)
    if a.products_count > 30000
      Resque.enqueue_at(a.products_count.seconds.from_now, CategoryProductRandomCacheWorker, category_id)
    else
      Resque.enqueue_at(4.hours.from_now, CategoryProductRandomCacheWorker, category_id)
    end
  end
  
end

