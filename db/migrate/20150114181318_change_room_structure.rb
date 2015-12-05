class ChangeRoomStructure < ActiveRecord::Migration
  def change

	  drop_table :rooms

	  add_column :teachers, :room_title, :string

  end
end
