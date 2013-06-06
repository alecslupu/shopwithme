class AddUriToSystemExceptions < ActiveRecord::Migration
  def change
    add_column :system_exceptions, :uri, :string
  end
end
