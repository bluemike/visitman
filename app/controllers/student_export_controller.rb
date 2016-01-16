class StudentExportController < ApplicationController

	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end

	end

	def student_export
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end
		@students = Student.where("event_id=%d", getLoginEventId).all
		send_data @students.to_csv,
				  type: 'text/csv; header=present',
				  disposition: "attachment; filename=students.csv"

		return
	end

end

