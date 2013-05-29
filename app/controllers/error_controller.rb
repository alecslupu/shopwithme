class ErrorController < ApplicationController

  layout 'error'

  def show
    template = request.path[1..-1]
    render template , :layout => 'error', :status => template
  end 
end
