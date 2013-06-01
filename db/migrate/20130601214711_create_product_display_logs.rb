class CreateProductDisplayLogs < ActiveRecord::Migration
  def change
    create_table :product_display_logs do |t|
      t.references :product
      t.string :user_agent
      t.string :ip
      t.text :referrer

      t.timestamps
    end
    add_index :product_display_logs, :product_id
  end
end
