class DealsController < ApplicationController
  def index
    @deals = Deal.includes(:advertiser => :category).active.where('code IN  (?)', ['n/a','N/A']).order('end_date').page(params[:page])
  end

  def visit
  end

end
