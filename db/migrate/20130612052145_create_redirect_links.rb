class CreateRedirectLinks < ActiveRecord::Migration
  def change
    create_table :redirect_links do |t|
      t.string :from_link
      t.string :to_link
      t.integer :redirect_count

      t.timestamps
    end
    add_index :redirect_links, :from_link
  end
end
