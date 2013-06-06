class AdvertiserWorker < ResqueJob
  @queue = :advertiser

  def self.perform
    ActiveRecord::Base.verify_active_connections!

    advertiser = AdvertiserDemon.new
    advertiser.process


    Resque.remove_delayed(AdvertiserWorker)
    Resque.enqueue_at(Time.now.end_of_day+10.minutes, AdvertiserWorker)
  end 
end