class ApplicationController < ActionController::Base
  protect_from_forgery
end
=begin
Delayed::Job.enqueue CategoryJob.new.perform



  def async_add_achievement_to_users
    Resque.enqueue(CategoryWorker)
    Resque.enqueue(AdvertiserWorker)
    
  end


=end