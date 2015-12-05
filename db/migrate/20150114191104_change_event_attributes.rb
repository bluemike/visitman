class ChangeEventAttributes < ActiveRecord::Migration
	def change
		remove_column :events, :reg_from_date
		remove_column :events, :reg_to_date
		remove_column :events, :info_from_date
		remove_column :events, :info_to_date

		add_column :events, :teacher_reg_from_date, :datetime
		add_column :events, :teacher_reg_to_date, :datetime
		add_column :events, :student_reg_from_date, :datetime
		add_column :events, :student_reg_to_date, :datetime

	end
end
