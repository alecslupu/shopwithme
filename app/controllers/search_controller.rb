class SearchController < ApplicationController


  def index

    search_products     if params[:type] == 'product' 
    search_brands       if params[:type] == 'brand' 
    search_categories   if params[:type] == 'category' 
    search_advertisers  if params[:type] == 'advertiser' 
    
    @results = Sunspot.search(Product, Category, Advertiser, Brand)  do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 10
    end.results
  end

  def chrome
    @products = Product.search do
      keywords params[:search].split(" ")
      paginate :page => 1, :per_page => 2
    end.results

    respond_to do |format|
      format.json { render_json @products }
    end 
  end 

  private 
  def render_json(json)
    unless json.nil?
      json = json.map{ |product| {
        :name => product.name, 
        :link => product_url(product), 
        :image => product.aw_image_url,
        :category_name => product.category.try(:name), 
        :category_url => product.category.nil? ? nil : category_url(product.category), 
        :description => product.short_description(20)
      }}
    end
    json = {:more_results_link => search_products_url(:search => params[:search]), :products => json}.to_json
    callback = params[:callback]
    response = begin
      if callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({ :js => response})
  end

  def search_categories
    redirect_to search_categories_path(:search => params[:search]) and return 
  end 

  def search_advertisers
    redirect_to search_advertisers_path(:search => params[:search]) and return 
  end 

  def search_brands
    redirect_to search_brands_path(:search => params[:search]) and return 
  end 

  def search_products
    redirect_to search_products_path(:search => params[:search]) and return 
  end
end
