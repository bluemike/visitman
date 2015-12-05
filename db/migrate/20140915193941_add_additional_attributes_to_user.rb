class AddAdditionalAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :country, :string
    add_column :users, :mobile, :string
    add_column :users, :last_login_at, :datetime
  end
end
