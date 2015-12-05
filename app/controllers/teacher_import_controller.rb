class TeacherImportController < ApplicationController

	# GET /slots
	# GET /slots.json
	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end
		$teacher_import_preview_list = []
		redirect_to action: 'show'
	end

	def show
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end
		@teachers = Teacher.where("event_id=%d",getLoginEventId).all
	end

	def delete_all_teachers
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end

		Teacher.destroy_all(["event_id = ?",getLoginEventId])
		flash[:alert] = "Es wurden alle Lehrer erfolgreich gelöscht!"
		redirect_to action: 'index'
	end

	def teacher_import
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end

		require 'csv'
		require 'charlock_holmes'

		status = true
		num_teachers = 0
		num_teams = 0
		num_groups = 0

		has_errors = false

		if params[:check]

			$teacher_import_preview_list = []

			content = params["teacher"]["file"].read
			detection = CharlockHolmes::EncodingDetector.detect(content)
			utf8_encoded_content = CharlockHolmes::Converter.convert content, detection[:encoding], 'UTF-8'

			CSV.parse(utf8_encoded_content, headers: false, col_sep: ';').each do |row|

				if !status
					has_errors = true
				end

				firstname = row[0]
				name = row[1]
				abbreviation = row[2]
				room_title = row[3]
				team_title = row[4]
				email = row[5]
				status = true
				message = ""

				if firstname == nil || firstname == '' || name == nil || name == ''
					status = false
					message = "Name/Vorname fehlt"
				end

				if abbreviation == nil || abbreviation == ''
					status = false
					message = "Kurzform fehlt"
				end

				if team_title == nil || team_title == ''
					team_title = ''
				end

				preview_entry = { name: name, firstname: firstname, abbreviation: abbreviation, room_title: room_title, email: email, team_title: team_title, status: status, message: message }
				$teacher_import_preview_list.push(preview_entry)

				num_teachers += 1

			end

			if !status
				has_errors = true
			end

			noticeString = "Es wurden %d Lehrer erfolgreich geprüft!" % [num_teachers]
			flash[:notice] = noticeString
			if has_errors
				alertString = "Es gab Fehler bei der Prüfung!"
				flash[:alert] = alertString
			end
			redirect_to action: 'show'

		else
			if $teacher_import_preview_list.length != 0

				$teacher_import_preview_list.each do |preview_entry|
					if preview_entry[:status]

						teacher = Teacher.new
						teacher.event_id = getLoginEventId
						teacher.name = preview_entry[:name]
						teacher.firstname = preview_entry[:firstname]
						teacher.abbreviation = preview_entry[:abbreviation]
						teacher.room_title = preview_entry[:room_title]
						teacher.email = preview_entry[:email]
						teacher.code = teacher.getCode
						teacher.changed_id = getLoginUserId

						team = Team.find_by_title(getLoginEventId,preview_entry[:team_title])
						team_id = nil
						if team == nil && preview_entry[:team_title] != ''
							# create team
							team = Team.new
							team.event_id = getLoginEventId
							team.title = preview_entry[:team_title]
							team.changed_id = getLoginUserId
							team.save
							team_id = team.id
							num_teams += 1
						elsif team != nil
							team_id = team.id
						end

						teacher.team_id = team_id

						if teacher.save
							num_teachers += 1
						end
					end
				end

				$teacher_import_preview_list = []

				noticeString = "Es wurden %d Lehrer und %d Klassen erfolgreich eingelesen!" % [num_teachers, num_teams]
				flash[:notice] = noticeString
				redirect_to action: 'show'
			else
				alertString = "Es wurden keine Lehrer eingelesen!" % [num_teachers]
				flash[:alert] = alertString
				redirect_to action: 'show'
			end
		end
	end


end

