class AdvertiserController < ApplicationController
  before_filter :find_advertiser, :only => [:show, :category]

  caches_action :show, :cache_path => :show_cache_path.to_proc

  def show
    @products = @advertiser.products.includes(:category).page params[:page]
  end

  def category
    @category = Category.find(params[:category_id])
    @products = @advertiser.products.where(:category_id => @category.id).page params[:page]
  end 

  def index 
    @advertisers = Advertiser.with_products.page params[:page]
  end 

  protected 

  def show_cache_path
    "advertiser/#{params[:id]}/page/#{params[:page]}"
  end 

  private 
  def find_advertiser
    @advertiser = Advertiser.find(params[:id])
  end 


end
