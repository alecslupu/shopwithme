class ProductFeedWorker < ResqueJob
  @queue = :product_feed

  def self.perform(merchant_id)
    ActiveRecord::Base.verify_active_connections!

    product_feed = ProductFeedDemon.new
    product_feed.process(merchant_id)
  end 
end