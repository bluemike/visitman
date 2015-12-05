class DropAndCreateUsers < ActiveRecord::Migration
  def change

    create_table :users do |t|

      t.string :email
      t.string :password
      t.boolean :active
      t.integer :role_type

      t.string :address, :string
      t.string :place, :string
      t.string :zip, :string
      t.integer :sex

      t.timestamps

    end
  end
end
