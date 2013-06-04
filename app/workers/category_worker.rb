class CategoryWorker < ResqueJob
  @queue = :cache

  def self.perform
    ActiveRecord::Base.verify_active_connections!

    category = CategoryDemon.new
    category.process
  end 
end