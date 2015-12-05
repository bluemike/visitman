class AddTeacherTeamTable < ActiveRecord::Migration
  def change

	  create_table :teacherteams do |t|


		  t.integer :changed_id
		  t.timestamps

	  end

	  add_column :teacherteams, :event_id, :integer, null: false
	  add_column :teacherteams, :teacher_id, :integer, null: false
	  add_column :teacherteams, :team_id, :integer, null: false

  end
end
