class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :changed_id, :integer
    add_index :users, :email, :unique => true
  end
end
