class BrandsController < ApplicationController
  def show
    @brand = Brand.find(params[:id])
    product_count = Rails.cache.fetch("all_brand_#{@brand.id}_products_count",:expires_in => 6.hours) { @brand.products.size }
    @products = @brand.products.page_with_cached_total_count(params[:page], product_count)
  end

  # def index
  #   if params[:chr].nil?
  #     @brands = Brand.ordered.page params[:page]
  #   elsif ("a".."z").to_a.include?(params[:chr].downcase)
  #     @brands = Brand.ordered.where("LOWER(name) LIKE ? ", "#{params[:chr].downcase}%").page params[:page]
  #   end
    
  # end
  def index
  end
end
