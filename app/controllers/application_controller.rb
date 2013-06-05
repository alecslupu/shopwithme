class ApplicationController < ActionController::Base
  protect_from_forgery

end
=begin
Delayed::Job.enqueue CategoryJob.new.perform



  def async_add_achievement_to_users
    Resque.enqueue(CategoryWorker)
    Resque.enqueue(AdvertiserWorker)
    Resque.enqueue(SitemapWorker)
    Resque.enqueue(CacheEnqueueWorker)
  end


=end