class ProductsController < ApplicationController

  def index 
    product_count = Rails.cache.fetch('all_products_count') { Product.count }
    @products = Product.includes(:category, :advertiser, :brand).page_with_cached_total_count params[:page], product_count
  end

  def show
    @product = Product.find(params[:id])
  end 

  def visit
    product = Product.find(params[:id])
    redirect_to product.aw_deep_link
  end

end
