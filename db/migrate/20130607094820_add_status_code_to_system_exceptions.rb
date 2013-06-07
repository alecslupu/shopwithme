class AddStatusCodeToSystemExceptions < ActiveRecord::Migration
  def change
    remove_column :system_exceptions, :uri

    add_column :system_exceptions, :status_code, :string
  end
end
