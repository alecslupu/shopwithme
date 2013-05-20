class AddIndexForAwProductId < ActiveRecord::Migration
  def change
    add_index :products, :aw_product_id
  end
end
