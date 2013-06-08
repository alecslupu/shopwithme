class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.references :advertiser
      t.references :country
      t.string :code
      t.string :description
      t.string :url
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :date_added

      t.timestamps
    end
    add_index :deals, :advertiser_id
    add_index :deals, :country_id
  end
end
