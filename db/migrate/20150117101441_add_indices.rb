class AddIndices < ActiveRecord::Migration
  def change
	  add_index :teacherteams, :event_id
	  add_index :teacherteams, :teacher_id
	  add_index :teacherteams, :team_id
	  add_index :reservations, :event_id
	  add_index :reservations, :teacher_id
	  add_index :reservations, :slot_id
	  add_index :reservations, :student_id
  end
end
