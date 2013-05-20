class AdvertiserWorker < ResqueJob
  @queue = :advertiser

  def self.perform
    ActiveRecord::Base.verify_active_connections!

    advertiser = AdvertiserDemon.new
    advertiser.process
  end 
end