class CreateRandomBrandProducts < ActiveRecord::Migration
  def change
    create_table :random_brand_products do |t|
      t.references :brand
      t.references :product

      t.timestamps
    end
    add_index :random_brand_products, :brand_id
    add_index :random_brand_products, :product_id
  end
end
