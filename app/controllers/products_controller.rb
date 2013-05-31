class ProductsController < ApplicationController
  before_filter :fix_missing_products , :only => :show


  def index 
    product_count = Rails.cache.fetch('all_products_count',:expires_in => 6.hours) { Product.count }
    @products = Product.includes(:category, :advertiser, :brand).page_with_cached_total_count params[:page], product_count
  end

  def show
    begin
      @product = Product.cached_find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render 'error/404', :layout => 'error', :status => :not_found
    end
  end 

  def visit
    product = Product.find(params[:id])
    redirect_to product.aw_deep_link
  end

  private 
  def fix_missing_products
    redirect_to_product(params[:id].gsub!('-amp', '')) if params[:id].include?('-amp')
    redirect_to_product(params[:id].gsub!('-quot', '')) if params[:id].include?('-quot')
    redirect_to_product(params[:id].gsub!('-39', '')) if params[:id].include?('-39')
    redirect_to_product(params[:id].gsub!('-pound', '')) if params[:id].include?('-pound')
  end

  def redirect_to_product(id)
    product = Product.cached_find id
    redirect_to product_path(product), :status => :moved_permanently
  end
end
