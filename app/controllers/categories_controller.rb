class CategoriesController < ApplicationController
  before_filter :ensure_search_term_presence, :only => [ :search ]

  caches_page :index, :show

  def show
    @category = Category.find(params[:id])
    product_count = Rails.cache.fetch("all_category_#{@category.id}_products_count",:expires_in => 6.hours) { @category.products.size }
    @products = @category.products.include_all.page_with_cached_total_count(params[:page], product_count) 
  end

  def index
    @categories = Category.alphabetically.with_products.page(params[:page])
  end

  def search 
    @categories = Category.search do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 10
    end
  end 

  private 

  def ensure_search_term_presence
    if params[:search].blank?
      redirect_to(categories_path) and return 
    end 
  end 
end
