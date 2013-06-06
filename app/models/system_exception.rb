class SystemException < ActiveRecord::Base
  # attr_accessible :backtrace, :exception_count, :message, :params

  def self.log(exception, params)
    return if false == exception.is_a?(Exception)
    exc = find_or_initialize_by_message(exception.message)
    exc.backtrace = exception.backtrace.join("\n")
    exc.params = params.to_json.to_s
    exc.increment(:exception_count)
    exc.save
  end
end
