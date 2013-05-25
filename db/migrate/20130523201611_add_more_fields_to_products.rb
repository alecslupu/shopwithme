class AddMoreFieldsToProducts < ActiveRecord::Migration
  def change
    change_table(:products, :bulk => true) do |t|
      t.string :merchant_category
      t.string :merchant_deep_link
      t.string :merchant_image_url
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

      t.string :pre_order
      t.string :product_type
      t.string :promotional_text
      t.string :upc
      t.text :warranty

      t.integer :parent_product_id
      t.float  :rrp_price
      t.string :web_offer
      t.text :specifications

    end
  end
end