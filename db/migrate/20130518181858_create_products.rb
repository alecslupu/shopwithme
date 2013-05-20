class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :advertiser
      t.references :category
      t.integer :aw_product_id
      t.integer :merchant_product_id
      t.string :name
      t.string :slug
      t.text :description
      t.text :aw_deep_link
      t.string :aw_image_url
      t.string :aw_thumb_url
      t.float :search_price
      t.string :currency
      t.float :delivery_cost
      t.datetime :valid_to
      t.datetime :valid_from
      t.integer :stock_quantity
      t.string :model_number
      t.references :brand

      t.timestamps
    end
    add_index :products, :advertiser_id
    add_index :products, :category_id
    add_index :products, :brand_id
    add_index :products, :slug, unique: true
  end
end
