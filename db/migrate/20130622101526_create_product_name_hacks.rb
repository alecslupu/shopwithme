class CreateProductNameHacks < ActiveRecord::Migration
  def self.up
    create_table :product_name_hacks do |t|
      t.string :pname
      t.string :pslug
      t.string :htmlent
    end

    add_index :product_name_hacks, :htmlent
  end
  def self.down
    drop_table :product_name_hacks
  end
end
