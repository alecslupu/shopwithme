class AdvertisersController < ApplicationController
  before_filter :ensure_search_term_presence, :only => [ :search ]

  # caches_page :index, :show

  def show
    @advertiser = Advertiser.find(params[:id])
    product_count = Rails.cache.fetch("all_advertiser_#{@advertiser.id}_products_count",:expires_in => 6.hours) { @advertiser.products.size  }
    @products = @advertiser.products.includes(:category, :advertiser).page_with_cached_total_count(params[:page], product_count)
  end

  def index
    @advertisers = Advertiser.alphabetically.with_products.page(params[:page])
  end

  def search 
    @advertisers = Advertiser.search do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 10
    end
  end 

  private 

  def ensure_search_term_presence
    if params[:search].blank?
      redirect_to(advertisers_path) and return 
    end 
  end
end
