class CreateProductFastImports < ActiveRecord::Migration
  def change
    create_table :product_fast_imports do |t|
      t.string :merchant_id
      t.string :merchant_category
      t.string :merchant_deep_link
      t.string :merchant_image_url
      t.string :aw_thumb_url
      t.string :commission_group
      t.string :condition
      t.string :delivery_time
      t.string :ean
      t.string :in_stock
      t.string :isbn
      t.string :is_for_sale
      t.string :language
      t.string :merchant_thumb_url
      t.string :mpn
      t.string :parent_product_id
      t.string :pre_order
      t.string :product_type
      t.string :promotional_text
      t.string :rrp_price
      t.string :specifications
      t.string :upc
      t.string :warranty
      t.string :web_offer
      t.integer :aw_product_id
      t.integer :merchant_product_id
      t.string :product_name
      t.float :display_price
      t.float :store_price
      t.string :description
      t.integer :category_id
      t.string :aw_deep_link
      t.string :aw_image_url
      t.float :search_price
      t.string :currency
      t.float :delivery_cost
      t.string :brand_name
      t.integer :brand_id
      t.string :valid_to
      t.string :valid_from
      t.integer :stock_quantity
      t.string :model_number

      t.timestamps
    end
  end
end
