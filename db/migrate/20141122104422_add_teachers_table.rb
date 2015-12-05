class AddTeachersTable < ActiveRecord::Migration
  def change

	  create_table :teachers do |t|

		  t.string :name
		  t.string :firstname
		  t.string :abbreviation
		  t.string :code
		  t.string :email

		  t.integer :changed_id
		  t.timestamps

	  end

	  add_column :teachers, :event_id, :integer, null: false
	  add_column :teachers, :team_id, :integer, null: true

  end
end
