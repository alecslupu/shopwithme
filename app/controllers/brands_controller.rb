class BrandsController < ApplicationController
  def show
    @brand = Brand.find(params[:id])
    @products = @brand.products.page params[:page]
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
