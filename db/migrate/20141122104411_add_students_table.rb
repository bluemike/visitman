class AddStudentsTable < ActiveRecord::Migration

	def change

	  create_table :students do |t|

		  t.string :name
		  t.string :firstname
		  t.string :code
		  t.string :email
		  t.integer :changed_id

		  t.timestamps

	  end

	  add_column :students, :team_id, :integer, null: false
	  add_column :students, :event_id, :integer, null: false


  end
end
