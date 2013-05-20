class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.string :name
      t.string :slug
      t.string :logo
      t.boolean :active
      t.boolean :enabled
      t.integer :metadata_version
      t.string :strapline
      t.text :description
      t.string :click_through
      t.references :category
      t.string :url
      t.references :country

      t.timestamps
    end
    add_index :advertisers, :category_id
    add_index :advertisers, :country_id
    add_index :advertisers, :slug, unique: true
  end
end