class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name
      t.string :slug
      t.string :country_code

      t.timestamps
    end
    add_index :countries, :slug, unique: true

    Country.create([
      {:name => "United Kingdom", :country_code => "GB"},
      {:name => "United States of America", :country_code => "US"}
    ])
  end

  def self.down 
    drop_table :countries
  end 
end
