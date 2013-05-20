class AddProductCountToAdvertisers < ActiveRecord::Migration
  def change
    add_column :advertisers, :products_count, :integer

    Advertiser.all.each do |c|
      Advertiser.update_counters c.id, :products_count => c.products.count
    end
  end
end
