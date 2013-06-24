class ProductsController < ApplicationController
  before_filter :find_product, :only => [:show, :visit]
  before_filter :ensure_search_term_presence, :only => [ :search ]
  before_filter :redirect_to_product_view, :only => [ :show ]

  def index
    if bot?
      render :text => "", :status => :gone and return 
    else
      render :text => "", :status => :not_found and return 
    end
  end

  def show
    unless @product.nil?

      if request.path != product_path(@product)
        redirect_to @product, status: :moved_permanently and return 
      end

      log_product_view(@product)
      @@product = @product 
      @@terms = @product.name.gsub!("+", '')
      @products = Rails.cache.fetch("p#{@product.id}_similiar_products") do 
        Product.search do
          keywords @@terms.split(" "), :fields => [ :name ]
          without @@product
          paginate :page => 1, :per_page => 4
        end.results
      end
    end
  end 

  def search 
    @products = Product.search do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 10
    end
  end 

  def visit
    render :text => "", :status => :gone  and return if bot?

    ab_tests_finish if current_admin.nil? and not bot?

    log_product_visit(@product) unless @product.nil? 

    redirect_to @product.aw_deep_link
  end

  private 

  def find_product
    @product = Product.cached_find(params[:id])
  end 

  def redirect_to_product_view
    if current_admin.nil?  and not bot? 
      redirect_to visit_product_path(@product) and return 
    end
  end 

  def bot?
    request.user_agent.match(Split.configuration.robot_regex)
  end

  def ab_tests_finish
    finished('hide_price_in_show_page')
    finished('cta_visit_text')
    finished('cta_visit_color')
    finished('cta_visit_size')
    finished('details_link_to_visit_in_listing')
  end 

  def skip_log
    return ( not request.referer.nil? and request.referer.start_with?(root_url) and not bot? and not current_admin )
  end

  def log_product_view(product) 
    product.display_logs.create({
      :referrer => request.referer, 
      :user_agent => request.user_agent, 
      :ip => request.remote_ip
    }) unless skip_log 

  end 

  def log_product_visit(product)
    product.visit_logs.create({
      :user_agent => request.user_agent, 
      :ip => request.remote_ip
    }) unless bot?
  end

  def ensure_search_term_presence
    if params[:search].blank?
      redirect_to(products_path) and return 
    end 
  end 
end
