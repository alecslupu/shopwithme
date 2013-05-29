class CreateRandomAdvertiserProducts < ActiveRecord::Migration
  def change
    create_table :random_advertiser_products do |t|
      t.references :advertiser
      t.references :product

      t.timestamps
    end
    add_index :random_advertiser_products, :advertiser_id
    add_index :random_advertiser_products, :product_id
  end
end
