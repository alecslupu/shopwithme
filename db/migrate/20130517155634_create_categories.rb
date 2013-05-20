class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.string :slug


      t.string :name
      t.integer :awid 
      t.boolean :is_adult
      t.text :description

      t.timestamps
    end
    add_index :categories, :slug, unique: true
  end
end
