class StudentImportController < ApplicationController

	# GET /slots
	# GET /slots.json
	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end
		$student_import_preview_list = []
		redirect_to action: 'show'
	end

	def show
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end
		@students = Student.where("event_id=%d", getLoginEventId).includes(:team).all
	end

	def delete_all_students
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end

		Student.destroy_all(["event_id = ?", getLoginEventId])
		Team.destroy_all(["event_id = ?", getLoginEventId])
		flash[:alert] = "Es wurden alle Schüler und Klassen erfolgreich gelöscht!"
		redirect_to action: 'index'
	end

	def student_import
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end

		require 'rchardet'
		require 'acsv'

		status = true
		num_students = 0
		num_teams = 0
		has_errors = false

		has_errors = false

		if params[:check]

			$student_import_preview_list = []

			content = params["student"]["file"].read.to_s
			content = content.force_encoding('utf-8').encode('utf-8')

			ACSV::CSV.parse(content, headers: false) do |row|

				if !status
					has_errors = true
				end

				firstname = row[0]
				name = row[1]
				team_title = row[2]
				email = row[3]
				status = true
				message = ""

				if firstname == nil || firstname == '' || name == nil || name == ''
					status = false
					message = "Name/Vorname fehlt"
				end

				team = nil
				if team_title != nil
					team = Team.find_by_title(getLoginEventId, team_title)
				end

				if team_title == nil || team_title == ''
					team_title = ''
					status = false
					message = "Klasse fehlt"
				end

				preview_entry = {name: name, firstname: firstname, email: email, team_title: team_title, status: status, message: message}
				$student_import_preview_list.push(preview_entry)

				num_students += 1

			end

			if !status
				has_errors = true
			end

			noticeString = "Es wurden %d Schüler erfolgreich geprüft!" % [num_students]
			flash[:notice] = noticeString
			if has_errors
				alertString = "Es gab Fehler bei der Prüfung!"
				flash[:alert] = alertString
			end
			redirect_to action: 'show'

		else
			if $student_import_preview_list.length != 0

				$student_import_preview_list.each do |preview_entry|
					if preview_entry[:status]

						student = Student.new
						student.event_id = getLoginEventId
						student.name = preview_entry[:name]
						student.firstname = preview_entry[:firstname]
						student.email = preview_entry[:email]
						student.code = student.getCode
						student.changed_id = getLoginUserId

						team = Team.find_by_title(getLoginEventId, preview_entry[:team_title])
						if team == nil
							# create team
							team = Team.new
							team.event_id = getLoginEventId
							team.title = preview_entry[:team_title]
							team.changed_id = getLoginUserId
							team.save
							num_teams += 1
						end
						student.team_id = team.id

						if student.save
							num_students += 1
						end
					end
				end

				$student_import_preview_list = []

				noticeString = "Es wurden %d Schüler und %d Klassen erfolgreich eingelesen!" % [num_students, num_teams]
				flash[:notice] = noticeString
				redirect_to action: 'show'
			else
				alertString = "Es wurden keine Schüler eingelesen!" % [num_students]
				flash[:alert] = alertString
				redirect_to action: 'show'
			end
		end
	end


end

