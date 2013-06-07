class ErrorController < ApplicationController

  layout 'error'

  def show
    exception = env["action_dispatch.exception"]
    template = request.path[1..-1]
    SystemException.log(exception, params,template) if exception 

    render template , :layout => 'error', :status => template
  end


end


