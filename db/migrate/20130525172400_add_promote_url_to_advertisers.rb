class AddPromoteUrlToAdvertisers < ActiveRecord::Migration
  def change
    add_column :advertisers, :promote_url, :string

  end
end
