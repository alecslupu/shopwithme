class AddDisplayPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :display_price, :float
    add_column :products, :store_price, :float
  end
end
