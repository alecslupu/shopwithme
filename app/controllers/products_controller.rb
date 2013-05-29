class ProductsController < ApplicationController

  def index 
    product_count = Rails.cache.fetch('all_products_count',:expires_in => 6.hours) { Product.count }
    @products = Product.includes(:category, :advertiser, :brand).page_with_cached_total_count params[:page], product_count
  end

  def show
    begin
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render 'error/404'
    end
  end 

  def visit
    product = Product.find(params[:id])
    redirect_to product.aw_deep_link
  end

end
