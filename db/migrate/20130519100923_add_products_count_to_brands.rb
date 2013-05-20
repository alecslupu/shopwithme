class AddProductsCountToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :products_count, :integer

    Brand.all.each do |c|
      Brand.update_counters c.id, :products_count => c.products.count
    end
  end
end
