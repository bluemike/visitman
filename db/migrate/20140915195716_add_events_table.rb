class AddEventsTable < ActiveRecord::Migration

  def change

    create_table :events do |t|

      t.string :title
      t.string :description

      t.boolean :active

      t.datetime :is_from_date
      t.datetime :is_to_date
      t.datetime :reg_from_date
      t.datetime :reg_to_date
      t.datetime :info_from_date
      t.datetime :info_to_date
      t.integer :default_slot_duration

      t.integer :changed_id
      t.timestamps

    end
  end
end
