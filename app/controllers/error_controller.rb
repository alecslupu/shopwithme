class ErrorController < ApplicationController

  def show
    render action: request.path[1..-1]
  end 
end
