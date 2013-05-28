class ApplicationController < ActionController::Base
  protect_from_forgery

  # unless Rails.env == "development"
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    # rescue_from Exception, :with => :render_error
  # end

  private 
  
  def render_not_found(exception)
    render "/error/404", :layout => 'error', :status => 404
  end

end
=begin
Delayed::Job.enqueue CategoryJob.new.perform



  def async_add_achievement_to_users
    Resque.enqueue(CategoryWorker)
    Resque.enqueue(AdvertiserWorker)
    Resque.enqueue(SitemapWorker)
    
  end


=end