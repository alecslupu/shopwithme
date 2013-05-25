class AddProductsCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :products_count, :integer


    Category.all.each do |c|
      Category.update_counters c.id, :products_count => c.products.count
    end
  end
end
