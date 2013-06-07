class AddStatusCodeToSystemExceptions < ActiveRecord::Migration
  def change
    add_column :system_exceptions, :status_code, :string
  end
end
