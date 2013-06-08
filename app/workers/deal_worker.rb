class DealWorker < ResqueJob
  @queue = :deal

  def self.perform
    ActiveRecord::Base.verify_active_connections!

    deal = DealDemon.new
    deal.process

    Resque.remove_delayed(DealWorker)
    Resque.enqueue_at(Time.now.end_of_day + 10.minutes, DealWorker)
  end 
end