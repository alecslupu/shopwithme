class BrandsController < ApplicationController
  def show
  end

  def index
    if params[:chr].nil?
      @brands = Brand.ordered.page params[:page]
    elsif ("a".."z").to_a.include?(params[:chr].downcase)
      @brands = Brand.ordered.where("LOWER(name) LIKE ? ", "#{params[:chr].downcase}%").page params[:page]
    end
      
  end
end