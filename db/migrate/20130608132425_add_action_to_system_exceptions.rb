class AddActionToSystemExceptions < ActiveRecord::Migration
  def change
    add_column :system_exceptions, :action, :string
  end
end
