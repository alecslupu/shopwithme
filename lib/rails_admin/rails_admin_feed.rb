require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminFeed
end

module RailsAdmin
  module Config
    module Actions
      class Feed < RailsAdmin::Config::Actions::Base

        RailsAdmin::Config::Actions.register(self)
        # There are several options that you can set here. 
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.
 
        register_instance_option :bulkable? do
          true
        end

        register_instance_option :member? do
          true
        end
 
        register_instance_option :controller do
          Proc.new do

            if params[:bulk_action]

              @objects = list_entries(@model_config, :destroy)
              @objects.each do |object|
                Resque.enqueue(ProductFeedWorker, object.id)
              end

            else 
              
              Resque.enqueue(ProductFeedWorker, @object.id)
              
            end
 
            flash[:success] = "#{@model_config.label} successfully published."
 
            redirect_to back_or_index
          end
        end
      end
    end
  end
end