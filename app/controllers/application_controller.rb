class ApplicationController < ActionController::Base
  protect_from_forgery

  protected 
  def current_request_url
    request.protocol + request.host_with_port + request.fullpath
  end
end
=begin
Delayed::Job.enqueue CategoryJob.new.perform

  def async_add_achievement_to_users
    Resque.enqueue(CacheEnqueueWorker)
  end

=end