class AddRoomsTable < ActiveRecord::Migration
  def change

      create_table :rooms do |t|

        t.string :title
        t.string :description

        t.integer :changed_id
        t.timestamps

      end

      add_column :rooms, :event_id, :integer, null: false

  end

end
