class CategoriesController < ApplicationController
  # caches_page :index, :show

  def show
    @category = Category.find(params[:id])
    product_count = Rails.cache.fetch("all_category_#{@category.id}_products_count",:expires_in => 6.hours) { @category.products.size }
    @products = @category.products.include_all.page_with_cached_total_count(params[:page], product_count) 
  end

  def index
    @categories = Category.alphabetically.with_products.page(params[:page])
  end

end
