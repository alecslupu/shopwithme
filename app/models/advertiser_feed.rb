class AdvertiserFeed < ActiveRecord::Base
  belongs_to :advertiser
  attr_accessible :feed_last_modified, :feed_last_refresh, :feed_product_count, :feed_version
end
