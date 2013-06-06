class ErrorController < ApplicationController

  layout 'error'

  def show
    exception = env["action_dispatch.exception"]
    SystemException.log(exception, params, request.url) if exception 

    template = request.path[1..-1]
    render template , :layout => 'error', :status => template
  end


end
