class AddNameFirstNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :firstname, :string
  end
end
