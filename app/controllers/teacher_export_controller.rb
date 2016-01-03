class TeacherExportController < ApplicationController

	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end

	end

	def teacher_export
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end
		@teachers = Teacher.where("event_id=%d", getLoginEventId).all
		send_data @teachers.to_csv,
				  type: 'text/csv; header=present',
				  disposition: "attachment; filename=teachers.csv"
	end

end

