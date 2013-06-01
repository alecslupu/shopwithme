class CreateProductVisitLogs < ActiveRecord::Migration
  def change
    create_table :product_visit_logs do |t|
      t.references :product
      t.string :user_agent
      t.string :ip

      t.timestamps
    end
    add_index :product_visit_logs, :product_id
  end
end
