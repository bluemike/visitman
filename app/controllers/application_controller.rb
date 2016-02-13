class ApplicationController < ActionController::Base
	# force_ssl if: :ssl_configured?

	TIMEOUTforLOGIN = 300

	helper_method :ConvertToDate, :ConvertToDateString, :getNiceDateString, :getNiceDateonlyString, :getNiceTimeString
	helper_method :checkLogin, :isLogin, :getLoginUserId, :getLoginNameString, :getLoginFirstNameString, :getLoginRoleType, :getLoginRoleTypeValue
	helper_method :isLoginRoleType, :selectedEvent, :getLoginEventString, :getLoginEventId, :getPreviousLoginValue
	helper_method :getEventCollectionbyStatus, :getTeamCollectionbyEventId, :getTeacherCollectionbyEventId

	helper_method :isTeachmanLogin, :getTeachmanLoginId, :getTeachmanLoginEventId, :getTeachmanLoginEventString, :getTeachmanLoginFirstnameNameString, :getTeachmanTeamTeacher, :getTeachmanLoginRoomString
	helper_method :isStudmanLogin, :getStudmanLoginId, :getStudmanLoginEventId, :getStudmanLoginEventString, :getStudmanLoginFirstnameNameString, :getStudmanTeamId, :getStudmanTeamString

	helper_method :checkStudmanLogin, :checkTeachmanLogin

	helper_method :displayPDF, :printStudentReservations

	def ssl_configured?
		!Rails.env.development?
	end

	def checkStudmanLogin
		if session[:student_id] != nil
			lastlogin = session[:lastlogin]
			tfl = TIMEOUTforLOGIN
			tn = Time.now.to_i

			if lastlogin != nil
				timediff = (tn - lastlogin.to_i)
				if (timediff > tfl)
					return false
				else
					session[:lastlogin] = Time.now.to_i
					return true
				end
			else
				return false
			end
		else
			return false
		end
		return false
	end

	def checkTeachmanLogin
		if session[:teacher_id] != nil
			lastlogin = session[:lastlogin]
			tfl = TIMEOUTforLOGIN
			tn = Time.now.to_i

			if lastlogin != nil
				timediff = (tn - lastlogin.to_i)
				if (timediff > tfl)
					return false
				else
					session[:lastlogin] = Time.now.to_i
					return true
				end
			else
				return false
			end
		else
			return false
		end
		return false
	end

	def isStudmanLogin
		if session[:student_id] != nil
			return true
		end
		return false
	end

	def getStudmanLoginId
		if session[:student_id] != nil
			return session[:student_id]
		end
		return -1
	end

	def getStudmanLoginEventId
		if isStudmanLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.id
			end
		end
		return -1
	end

	def getStudmanLoginEventString
		if isStudmanLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.title
			end
		end
		return "n/a"
	end

	def getStudmanLoginFirstnameNameString
		if isStudmanLogin
			return "%s %s" % [session[:student_firstname], session[:student_name]]
		end
		return "n/a"
	end

	def getStudmanTeamId
		if session[:team_id] != nil
			return session[:team_id]
		end
		return -1
	end

	def getStudmanTeamString
		if session[:team_id] != nil
			team = Team.find(session[:team_id])
			return team.title
		end
		return "n/a"
	end

	def isTeachmanLogin
		if session[:teacher_id] != nil
			return true
		end
		return false
	end

	def getTeachmanLoginId
		if session[:teacher_id] != nil
			return session[:teacher_id]
		end
		return -1
	end

	def getTeachmanLoginEventId
		if isTeachmanLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.id
			end
		end
		return -1
	end

	def getTeachmanLoginEventString
		if isTeachmanLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.title
			end
		end
		return "n/a"
	end

	def getTeachmanLoginRoomString
		if isTeachmanLogin
			return session[:teacher_room_title]
		end
		return "n/a"
	end

	def getTeachmanLoginFirstnameNameString
		if isTeachmanLogin
			return "%s %s" % [session[:teacher_firstname], session[:teacher_name]]
		end
		return "n/a"
	end

	def getTeachmanTeamTeacher
		teacher_id = getTeachmanLoginId
		if teacher_id != -1
			teachers = Teacher.where(id: teacher_id)
			if teachers != nil
				teacher = teachers[0]
				if teacher.team_id != nil
					teams = Team.where(id: teacher.team_id)
					if teams != nil
						return teacher.team_id
					end
				end
			end
			return -1
		end
	end

	def ConvertToDate(value)
		convertdate = Time.zone.parse(value)
		return convertdate
	end

	def ConvertToDateString(value)
		return getNiceDateString(value)
	end

	def getNiceDateString(value)
		if value != nil
			return value.strftime("%d.%m.%Y %H:%M")
		end
		return "n/a"
	end

	def getNiceDateonlyString(value)
		if value != nil
			return value.strftime("%d.%m.%Y")
		end
		return "n/a"
	end

	def getNiceTimeString(value)
		if value != nil
			return value.strftime("%H:%M")
		end
		return "n/a"
	end

	def checkLogin (email, password)
		loginuser = User.find_by email: email
		if loginuser!=nil && loginuser.password == password
			return loginuser
		end
		return nil
	end

	def isLogin
		if session[:user_id] != nil
			return true
		end
		return false
	end

	def getLoginUserId
		if isLogin
			return session[:user_id]
		end
		return "n/a"
	end

	def getLoginNameString
		if isLogin
			return session[:user_name]
		end
		return "n/a"
	end

	def getLoginFirstNameString
		if isLogin
			return session[:user_firstname]
		end
		return "n/a"
	end

	def getLoginRoleType
		if isLogin
			return session[:user_role_type]
		end
		return 0
	end

	def getLoginRoleTypeValue
		if isLogin
			newuser = User.new
			return newuser.getRoleTypeValue(session[:user_role_type])
		end
		return "n/a"
	end

	def isLoginRoleType (reference_role_type)
		if isLogin
			if session[:user_role_type] == reference_role_type
				return true
			end
		end
		return false
	end

	def selectedEvent
		if isLogin
			if session[:event_id] != nil
				return true
			end
		end
		return false
	end

	def getLoginEventId
		if isLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.id
			end
		end
		return -1
	end

	def getLoginEventString
		if isLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.title
			end
		end
		return "n/a"
	end

	def getPreviousLoginValue
		if isLogin
			if session[:previous_login] != nil
				return session[:previous_login]
			end
		end
		return Time.now
	end

	def getEventCollectionbyStatus(value)
		return Event.where("active=%s", value).all
	end

	def getTeamCollectionbyEventId(event_id)
		return Team.where("event_id=%d", event_id).all.order(title: :asc)
	end

	def getTeacherCollectionbyEventId(event_id)
		teachers = Teacher.where("event_id=%d", event_id).order(abbreviation: :asc)
		teacher_list = []
		teachers.each do |teacher|
			teacher_string = "%s %s (%s)" % [teacher.firstname, teacher.name, teacher.abbreviation]
			teacher_entry = [teacher_string, teacher.id]
			teacher_list << teacher_entry
		end
		return teacher_list
	end

	def displayPDF eventString, dateString, titleString, dataArray, colorArray, widthArray

		pdf = Prawn::Document.new(:page_size => 'A4', :page_layout => :portrait)

		pdf.image "#{Rails.root}/app/assets/images/schoolfrick.png", at: [0, 780]
		pdf.draw_text eventString, size: 24, style: :bold, at: [250, 720]

		pdf.move_down 80
		pdf.text dateString, size: 16, style: :bold
		pdf.text titleString, size: 16, style: :bold
		pdf.move_down 40

		pdf.table dataArray do

			# make header row bold
			style(row(0), font_style: :bold)

			i = 0
			while i < row_length do
				if i == 0
					style(row(i), background_color: "FFFFFF")
				else
					if i.odd?
						style(row(i), background_color: "F0F0F0")
					end
				end

				j = 0
				colorArray[i].each do |color_entry|
					if color_entry != nil
						style(row(i).column(j), background_color: color_entry)
					end
					j += 1
				end

				j = 0
				widthArray[0].each do |width_entry|
					if width_entry != nil
						style(row(i).column(j), width: width_entry)
					end
					j += 1
				end

				i += 1

			end

		end

		send_data pdf.render, :filename => "x.pdf", :type => "application/pdf"

	end

	def printTeacherReservations event_id, teacher_id, slot_date, slot_list

		teacher = Teacher.find(teacher_id)
		event = Event.find(event_id)

		temp_slot = Slot.new
		eventString = event.title
		dateString = temp_slot.getNiceDateonlywithDayofWeekString(slot_date.to_date)
		titleString = "%s %s (%s) im Zimmer %s" % [teacher.firstname, teacher.name, teacher.abbreviation, teacher.room_title]

		dataArray = []
		colorArray = []
		widthArray = []

		header_entry = ["von", "bis", "Reservation"]
		dataArray << header_entry
		colorArray << [nil, nil, nil]
		widthArray << [nil, nil, 300]

		slot_list.each do |slot|

			from_datetime = slot.from_time
			to_datetime = slot.to_time

			student_string = ""
			status = nil

			reservations = Reservation.where(event_id: event_id, teacher_id: teacher_id, slot_id: slot.id)
			if reservations.length > 0
				reservation = reservations[0]
				status = reservation.status
				if reservation.student_id != nil
					student = Student.find(reservation.student_id)
					team = Team.find(student.team_id)
					student_string = "%s %s (%s)" % [student.firstname, student.name, team.title]
					status = Reservation::RESERVATION_AVAILABILITY_BOOKED
				end
			end

			row_entry = []
			row_entry << getNiceTimeString(from_datetime)
			row_entry << getNiceTimeString(to_datetime)
			row_entry << student_string

			color_entry = []
			color_entry << nil
			color_entry << nil
			if status != nil
				color_entry << reservation.getReservationAvailabilityPrintColor(status)
			else
				color_entry << nil
			end

			dataArray << row_entry
			colorArray << color_entry

		end

		displayPDF eventString, dateString, titleString, dataArray, colorArray, widthArray

	end

	def printStudentReservations event_id, student_id, slot_date, slot_list

		student = Student.find(student_id)
		team = Team.find(student.team_id)
		event = Event.find(event_id)

		temp_slot = Slot.new
		eventString = event.title
		dateString = temp_slot.getNiceDateonlywithDayofWeekString(slot_date.to_date)
		titleString = "%s %s (%s)" % [student.firstname, student.name, team.title]

		dataArray = []
		colorArray = []
		widthArray = []

		header_entry = ["von", "bis", "Reservation", "Zimmer"]
		dataArray << header_entry
		colorArray << [nil, nil, nil, nil]
		widthArray << [nil, nil, 300, 100]

		slot_list.each do |slot|

			from_datetime = slot.from_time
			to_datetime = slot.to_time

			teacher_string = ""
			room_string = ""
			status = nil

			reservations = Reservation.where(event_id: event_id, student_id: student_id, slot_id: slot.id)
			if reservations.length > 0
				reservation = reservations[0]
				status = reservation.status
				if reservation.student_id != nil
					teacher = Teacher.find(reservation.teacher_id)
					teacher_string = "%s %s (%s)" % [teacher.firstname, teacher.name, teacher.abbreviation]
					room_string = teacher.room_title
					status = Reservation::RESERVATION_AVAILABILITY_BOOKED
				end
			end

			row_entry = []
			row_entry << getNiceTimeString(from_datetime)
			row_entry << getNiceTimeString(to_datetime)
			row_entry << teacher_string
			row_entry << room_string

			color_entry = []
			color_entry << nil
			color_entry << nil
			if status != nil
				color_entry << reservation.getReservationAvailabilityPrintColor(status)
			else
				color_entry << nil
			end
			color_entry << nil

			dataArray << row_entry
			colorArray << color_entry

		end

		displayPDF eventString, dateString, titleString, dataArray, colorArray, widthArray

	end

	def printTeamTeachers event_id, team_id

		team = Team.find(team_id)
		event = Event.find(event_id)

		eventString = event.title
		dateString = ""
		titleString = "Lehrerliste der Klasse %s" % [team.title]

		teacherteams = Teacherteam.where(event_id: event_id, team_id: team_id)

		dataArray = []
		colorArray = []
		widthArray = []

		header_entry = ["Lehrkraft", "Kurzform"]
		dataArray << header_entry
		colorArray << [nil, nil]
		widthArray << [200, 100]

		teacherteams.each do |teacherteam|

			teacher_id = teacherteam.teacher_id
			teacher = Teacher.find(teacher_id)
			teacher_string = "%s %s" % [teacher.firstname, teacher.name]
			teacher_abbreviation_string = teacher.abbreviation

			row_entry = []
			row_entry << teacher_string
			row_entry << teacher_abbreviation_string

			color_entry = []
			color_entry << nil
			color_entry << nil

			dataArray << row_entry
			colorArray << color_entry

		end

		displayPDF eventString, dateString, titleString, dataArray, colorArray, widthArray

	end

	def printTeamStudents event_id, team_id

		team = Team.find(team_id)
		event = Event.find(event_id)

		eventString = event.title
		dateString = ""
		titleString = "Klassenliste %s" % [team.title]

		students = Student.where(event_id: event_id, team_id: team_id)

		dataArray = []
		colorArray = []
		widthArray = []

		header_entry = ["Vorname", "Nachname"]
		dataArray << header_entry
		colorArray << [nil, nil]
		widthArray << [200, 200]

		students.each do |student|

			row_entry = []
			row_entry << student.firstname
			row_entry << student.name

			color_entry = []
			color_entry << nil
			color_entry << nil

			dataArray << row_entry
			colorArray << color_entry

		end

		displayPDF eventString, dateString, titleString, dataArray, colorArray, widthArray

	end

end


