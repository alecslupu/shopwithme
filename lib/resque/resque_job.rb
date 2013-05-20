class ResqueJob 
  extend Resque::Plugins::History
  @max_history = 50
  

  # # include NewRelic::Agent::Instrumentation::ControllerInstrumentation
  # def self.perform(*args)
  #   NewRelic::Control.instance['resque'] = true
  #   self.new.perform_wrapper(*args)
  # ensure
  #   NewRelic::Agent.shutdown
  # end

  # def add_custom_parameters(key, value)
  #   NewRelic::Agent.add_custom_parameters(key => value.to_s)
  # end
  
  # def perform_wrapper(*args)
  #   # :task seems available only for charged plan. When you test this with a free plan, you have to get rid of it.
  #   # perform_action_with_newrelic_trace(:name=>'perform') do
  #   perform_action_with_newrelic_trace(:name=>'perform', :category => :task) do
  #     begin
  #       perform(*args)
  #     ensure
  #       logger.flush if logger && logger.respond_to?(:flush)    
  #     end
  #   end
  # end
  
  # Override this method instead of the class method.
  def perform(*args)
    raise "extend this"
  end
  
  def logger
    Rails.logger
  end




end