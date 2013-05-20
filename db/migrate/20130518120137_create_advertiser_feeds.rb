class CreateAdvertiserFeeds < ActiveRecord::Migration
  def change
    create_table :advertiser_feeds do |t|
      t.integer :feed_version
      t.datetime :feed_last_refresh
      t.datetime :feed_last_modified
      t.integer :feed_product_count
      t.references :advertiser

      t.timestamps
    end
    add_index :advertiser_feeds, :advertiser_id
  end
end
