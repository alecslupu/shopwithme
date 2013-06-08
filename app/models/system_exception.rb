class SystemException < ActiveRecord::Base
  # attr_accessible :backtrace, :exception_count, :message, :params

  def self.log(exception, params, status_code)
    return if false == exception.is_a?(Exception)
    exc = where(:message => exception.message, :controller => params[:controller], :action => params[:action], :status_code => status_code).first_or_initialize
    exc.backtrace = exception.backtrace.join("\n")
    exc.params = params.to_json.to_s
    exc.increment(:exception_count)
    exc.save
  end
end
