class AddTeamsTable < ActiveRecord::Migration
	def change

		create_table :teams do |t|

			t.string :title
			t.string :description
			t.integer :changed_id

			t.timestamps
		end

		add_column :teams, :event_id, :integer, null: false

	end
end
