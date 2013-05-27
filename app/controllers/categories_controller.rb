class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    product_count = Rails.cache.fetch("all_category_#{@category.id}_products_count") { @category.products.size }
    @products = @category.products.page_with_cached_total_count(params[:page], product_count) 
  end

  def index
  end
end
