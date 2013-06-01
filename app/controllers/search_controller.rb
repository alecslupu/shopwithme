class SearchController < ApplicationController
  def index
    search_products     if params[:type] == 'product' 
    search_brands       if params[:type] == 'brand' 
    search_categories   if params[:type] == 'category' 
    search_advertisers  if params[:type] == 'advertiser' 
    
  end

  private 
  def search_categories
    redirect_to search_categories_path(:search => params[:search])
  end 

  def search_advertisers
    redirect_to search_advertisers_path(:search => params[:search])
  end 

  def search_brands
    redirect_to search_brands_path(:search => params[:search])
  end 

  def search_products
    redirect_to search_products_path(:search => params[:search])
  end
end
