class TeachmanController < ApplicationController

	layout 'teachman'

	helper_method :checkRegDate

	def checkLogin
		if !checkTeachmanLogin
			alertString = "Seit der letzten Anmeldung ist zuviel Zeit ohne Aktivität vergangen. Bitte melde dich erneut an!"
			flash.alert = alertString
			redirect_to action: 'login'
			return false
		else
			return true
		end
	end

	def checkRegDate
		event_id = getTeachmanLoginEventId
		if event_id != -1
			event = Event.find(event_id)
			time_now = Time.now
			reg_from_date = ConvertToDate(event.teacher_reg_from_date.to_s)
			reg_to_date = ConvertToDate(event.teacher_reg_to_date.to_s)
			if (reg_from_date <= time_now) && (time_now <= reg_to_date)
				return true
			end
		end
		return false
	end

	def index
		reset_session
		redirect_to action: 'login'
	end

	def login

		alertString = flash.alert
		noticeString = flash.notice
		reset_session

		if request.post?

			noticeString = nil
			alertString = nil

			login_not_possible = false

			loginCode = params[:teachman][:loginCode]
			loginFirstname = params[:teachman][:loginFirstname]
			loginevent_id = params[:teachman][:loginevent_id]

			if loginevent_id == nil
				eventcollection = getEventCollectionbyStatus(true)
				if eventcollection.length == 0
					alertString = "Es sind aktuell keine Anlässe verfügbar!"
					login_not_possible = true
				elsif eventcollection.length == 1
					loginevent_id = eventcollection[0].id
				end
			end
			if !login_not_possible
				tempteacher = Teacher.new
				loginteacher = tempteacher.checkTeacherLogin(loginevent_id, loginCode, loginFirstname)
				if loginteacher != nil
					noticeString = "Anmeldung ist erfolgt!"
					session[:teacher_id] = loginteacher.id
					session[:teacher_email] = loginteacher.email
					session[:teacher_name] = loginteacher.name
					session[:teacher_firstname] = loginteacher.firstname
					session[:teacher_room_title] = loginteacher.room_title
					session[:lastlogin] = Time.now.to_i
					session[:event_id] = loginevent_id
					redirect_to teachman_overview_path, notice: noticeString
				else
					alertString = "Die Angaben zur Anmeldung sind ungültig!"
				end

			end
			flash.alert = alertString
		else
			flash.alert = alertString
			flash.notice = noticeString
		end
	end

	def overview
		if !checkLogin
			return
		end

	end

	def manage_availability_slot_date_changed
		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		@slot_date = params[:manage_availability][:slot_date]
		session[:slot_date] = @slot_date
		redirect_to action: 'manage_availability'
	end

	def manage_availability
		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getTeachmanLoginEventId, session[:slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
		session[:slot_date] = @slot_date


		@availability_only = true

		# check if we have reservations with open status or no reservations

		@slot_list.each do |slot|
			reservations = Reservation.where(event_id: getTeachmanLoginEventId, slot_id: slot.id, teacher_id: getTeachmanLoginId)
			if reservations.length == 0
				@availability_only = false
			else
				reservation = reservations[0]
				if reservation.status == Reservation::RESERVATION_AVAILABILITY_OPEN
					@availability_only = false
				end
			end
		end

	end

	def manage_availability_availability_changed
		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		if params[:all_available] || params[:all_not_available]
			@slot_date = session[:slot_date]
			slots = Slot.where(event_id: getTeachmanLoginEventId)
			slots.each do |slot|
				if slot.slot_date.to_date == @slot_date.to_date
					reservations = Reservation.where(event_id: getTeachmanLoginEventId, slot_id: slot.id, teacher_id: getTeachmanLoginId)
					if reservations.length == 0
						reservation = Reservation.new
						reservation.event_id = getTeachmanLoginEventId
						reservation.teacher_id = getTeachmanLoginId
						reservation.slot_id = slot.id
					else
						reservation = reservations[0]
					end
					if reservation.status != Reservation::RESERVATION_AVAILABILITY_BOOKED
						if params[:all_available]
							reservation.status = Reservation::RESERVATION_AVAILABILITY_AVAILABLE
						else
							reservation.status = Reservation::RESERVATION_AVAILABILITY_NOT_AVAILABLE
						end
						reservation.save
					end
				end
			end
		else
			slot_id = params[:slot_id]
			new_availability = params[:new_availability]
			reservations = Reservation.where(event_id: getTeachmanLoginEventId, teacher_id: getTeachmanLoginId, slot_id: slot_id)
			if reservations.length == 0
				reservation = Reservation.new
				reservation.event_id = getTeachmanLoginEventId
				reservation.teacher_id = getTeachmanLoginId
				reservation.slot_id = slot_id
			else
				reservation = reservations[0]
			end
			reservation.status = new_availability
			reservation.save
		end
		redirect_to action: 'manage_availability'
	end

	def manage_room

		@page_header = "Zimmer-Zuweisung"

		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		@teacher = Teacher.find(getTeachmanLoginId)
		@firstnamename = "%s %s (%s)" % [@teacher.firstname, @teacher.name, @teacher.abbreviation]
		@room_title = @teacher.room_title
		@room_status = @teacher.getRoomStatus
		@room_comment = @teacher.getRoomComment
	end

	def manage_room_changed

		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		if request.post?

			teacher = Teacher.find(getTeachmanLoginId)
			room_title = params[:teachman_manage_room][:room_title]
			teacher.room_title = room_title
			teacher.save
			session[:teacher_room_title] = room_title
			redirect_to action: 'manage_room'
			flash.notice = "Das Zimmer wurde erfolgreich geändert!"
			return
		end

		redirect_to action: 'manage_room'
	end

	def view_reservations_slot_date_changed
		if !checkLogin
			return
		end

		@slot_date = params[:view_reservations][:slot_date]
		session[:slot_date] = @slot_date
		redirect_to action: 'view_reservations'
	end

	def view_reservations
		if !checkLogin
			return
		end

		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getTeachmanLoginEventId, session[:slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
		session[:slot_date] = @slot_date
	end

	def print_reservations
		if !checkLogin
			return
		end

		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getTeachmanLoginEventId, session[:slot_date]
		slot_date = get_slot_list_hash[:slot_date]
		slot_list = get_slot_list_hash[:slot_list]

		printTeacherReservations getTeachmanLoginEventId, getTeachmanLoginId, slot_date, slot_list
	end


	def view_teamteachers
		if !checkLogin
			return
		end

		if getTeachmanTeamTeacher == -1
			redirect_to action: 'overview'
			return
		end

		@team_id = getTeachmanTeamTeacher
		team = Team.find(@team_id)
		@team_title = team.title
		@teacherteams = Teacherteam.where(event_id: getTeachmanLoginEventId, team_id: @team_id)
	end

	def print_teamteachers

		if !checkLogin
			return
		end

		if getTeachmanTeamTeacher == -1
			redirect_to action: 'overview'
			return
		end

		printTeamTeachers getTeachmanLoginEventId, getTeachmanTeamTeacher

	end

	def view_teamstudents
		if !checkLogin
			return
		end

		if getTeachmanTeamTeacher == -1
			redirect_to action: 'overview'
			return
		end

		team_id = getTeachmanTeamTeacher
		team = Team.find(team_id)
		@team_title = team.title
		@students = Student.where(event_id: getTeachmanLoginEventId, team_id: team_id).order(name: :asc)
	end

	def print_teamstudents

		if !checkLogin
			return
		end

		if getTeachmanTeamTeacher == -1
			redirect_to action: 'overview'
			return
		end

		printTeamStudents getTeachmanLoginEventId, getTeachmanTeamTeacher

	end

	def logout
		noticeString = "Sie wurden erfolgreich abgemeldet!"
		redirect_to teachman_login_path, notice: noticeString
	end

end
