class CreateRandomCategoryProducts < ActiveRecord::Migration
  def change
    create_table :random_category_products do |t|
      t.references :category
      t.references :product

      t.timestamps
    end
    add_index :random_category_products, :category_id
    add_index :random_category_products, :product_id
  end
end
