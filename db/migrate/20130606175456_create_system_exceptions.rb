class CreateSystemExceptions < ActiveRecord::Migration
  def change
    create_table :system_exceptions do |t|
      t.text :backtrace
      t.text :params
      t.string :message
      t.integer :exception_count

      t.timestamps
    end
  end
end
