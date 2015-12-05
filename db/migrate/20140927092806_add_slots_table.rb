class AddSlotsTable < ActiveRecord::Migration

	def change

		create_table :slots do |t|

			t.datetime :slot_date
			t.datetime :from_time
			t.datetime :to_time

			t.timestamps

	  end

	  add_column :slots, :event_id, :integer, null: false

  end

end
