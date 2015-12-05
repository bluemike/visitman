class TeacherteamImportController < ApplicationController

	# GET /slots
	# GET /slots.json
	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		$teacherteam_import_preview_list = []
		redirect_to action: 'show'
	end

	def show
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@teacherteams = Teacherteam.where("event_id=%d",getLoginEventId).all
	end

	def delete_all_teacherteams
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

		Teacherteam.destroy_all(["event_id = ?",getLoginEventId])
		flash[:alert] = "Es wurden alle Lehrer-Klassenbeziehungen erfolgreich gelöscht!"
		redirect_to action: 'index'
	end

	def teacherteam_import
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

		require 'csv'
		require 'charlock_holmes'

		status = true
		num_teacherteams = 0

		has_errors = false

		if params[:check]

			$teacherteam_import_preview_list = []

			content = params["teacherteam"]["file"].read
			detection = CharlockHolmes::EncodingDetector.detect(content)
			utf8_encoded_content = CharlockHolmes::Converter.convert content, detection[:encoding], 'UTF-8'

			CSV.parse(utf8_encoded_content, headers: false, col_sep: ';').each do |row|

				if !status
					has_errors = true
				end

				abbreviation = row[0]
				team_title = row[1]
				status = true
				message = ""

				if abbreviation == nil || abbreviation == ''
					status = false
					message = "Kurzform fehlt"
				else
					temp_teachers = Teacher.where(event_id: getLoginEventId, abbreviation: abbreviation)
					if temp_teachers.length == 0
						status = false
						message = "Kurzform ungültig"
					end
				end

				if team_title == nil || team_title == ''
					status = false
					message = "Klasse fehlt"
				else
					temp_teams = Team.where(event_id: getLoginEventId, title: team_title)
					if temp_teams.length == 0
						status = false
						message = "Klasse ungültig"
					end
				end

				preview_entry = { abbreviation: abbreviation, team_title: team_title, status: status, message: message }
				$teacherteam_import_preview_list.push(preview_entry)

				num_teacherteams += 1

			end

			if !status
				has_errors = true
			end

			noticeString = "Es wurden %d Lehrer-/Klassenbeziehungen erfolgreich geprüft!" % [num_teacherteams]
			flash[:notice] = noticeString
			if has_errors
				alertString = "Es gab Fehler bei der Prüfung!"
				flash[:alert] = alertString
			end
			redirect_to action: 'show'

		else
			if $teacherteam_import_preview_list.length != 0

				$teacherteam_import_preview_list.each do |preview_entry|
					if preview_entry[:status]

						teacherteam = Teacherteam.new
						teacherteam.event_id = getLoginEventId

						temp_teachers = Teacher.where(event_id: getLoginEventId, abbreviation: preview_entry[:abbreviation])
						teacher = temp_teachers[0]
						team = Team.find_by_title(getLoginEventId, preview_entry[:team_title])
						teacherteam.teacher_id = teacher.id
						teacherteam.team_id = team.id
						teacherteam.changed_id = getLoginUserId
						if teacherteam.save
							num_teacherteams += 1
						end
					end
				end

				$teacherteam_import_preview_list = []

				noticeString = "Es wurden %d Lehrer-Klassenverbindungen erfolgreich eingelesen!" % [num_teacherteams]
				flash[:notice] = noticeString
				redirect_to action: 'show'
			else
				alertString = "Es wurden keine Lehrer eingelesen!" % [num_teacher_teams]
				flash[:alert] = alertString
				redirect_to action: 'show'
			end
		end
	end


end

