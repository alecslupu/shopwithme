class CategoryWorker < ResqueJob
  @queue = :category

  def self.perform
    ActiveRecord::Base.verify_active_connections!

    category = CategoryDemon.new
    category.process

    Resque.remove_delayed(CategoryWorker)
    Resque.enqueue_at(Time.now.end_of_day + 10.minutes, CategoryWorker)
  end 
end