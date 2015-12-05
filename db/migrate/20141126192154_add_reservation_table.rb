class AddReservationTable < ActiveRecord::Migration
  def change

	  create_table :reservations do |t|


		  t.integer :changed_id
		  t.integer :status
		  t.timestamps

	  end

	  add_column :reservations, :event_id, :integer, null: false
	  add_column :reservations, :teacher_id, :integer, null: false
	  add_column :reservations, :slot_id, :integer, null: false
	  add_column :reservations, :student_id, :integer, null: true

  end
end
