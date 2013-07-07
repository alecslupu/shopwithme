class BrandsController < ApplicationController
  caches_page :index, :show

  def show
    @brand = Brand.find(params[:id])
    product_count = Rails.cache.fetch("all_brand_#{@brand.id}_products_count",:expires_in => 6.hours) { @brand.products.size }
    @products = @brand.products.page_with_cached_total_count(params[:page], product_count)
  end

  def index
    @brands = Brand.alphabetically.with_products.page(params[:page])
  end
end
