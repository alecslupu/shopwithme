class AddControllerToSystemExceptions < ActiveRecord::Migration
  def change
    add_column :system_exceptions, :controller, :string
  end
end
