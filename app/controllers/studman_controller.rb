class StudmanController < ApplicationController

	layout 'studman'

	helper_method :checkRegDate

	def checkLogin
		if !checkStudmanLogin
			alertString = "Seit der letzten Anmeldung ist zuviel Zeit ohne Aktivität vergangen. Bitte melden Sie sich erneut an!"
			flash.alert = alertString
			redirect_to action: 'login'
			return false
		else
			return true
		end
	end

	def checkRegDate
		event_id = getStudmanLoginEventId
		if event_id != -1
			event = Event.find(event_id)
			time_now = Time.now
			reg_from_date = ConvertToDate(event.student_reg_from_date.to_s)
			reg_to_date = ConvertToDate(event.student_reg_to_date.to_s)
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

			loginCode = params[:studman][:loginCode]
			loginTeam = params[:studman][:loginTeam]
			loginFirstname = params[:studman][:loginFirstname]
			loginevent_id = params[:studman][:loginevent_id]

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
				tempstudent = Student.new
				loginstudent = tempstudent.checkStudentLogin(loginevent_id, loginCode, loginTeam, loginFirstname)
				if loginstudent != nil
					noticeString = "Anmeldung ist erfolgt!"
					session[:student_id] = loginstudent.id
					session[:student_email] = loginstudent.email
					session[:student_name] = loginstudent.name
					session[:student_firstname] = loginstudent.firstname
					session[:event_id] = loginevent_id
					session[:lastlogin] = Time.now.to_i
					tempteam = Team.new
					loginteam = tempteam.find_by_title(loginevent_id, loginTeam)
					session[:team_id] = loginteam.id
					redirect_to studman_overview_path, notice: noticeString, alert: alertString
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

	def manage_reservations_slot_date_changed
		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		@slot_date = params[:manage_reservations][:slot_date]
		session[:slot_date] = @slot_date
		redirect_to action: 'manage_reservations'
	end

	def manage_reservations
		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getStudmanLoginEventId, session[:slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
		session[:slot_date] = @slot_date
		@teacherteam_list = Teacherteam.where(event_id: getStudmanLoginEventId, team_id: getStudmanTeamId)
		@teacher_already_reserved_list = []
		@teacherteam_list.each do |teacherteam|
			reservations = Reservation.where(event_id: getStudmanLoginEventId, student_id: getStudmanLoginId, teacher_id: teacherteam.teacher_id)
			if reservations.length > 0
				@teacher_already_reserved_list << teacherteam.teacher_id
			end
		end
	end

	def manage_reservations_reservation_book
		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		slot_id = params[:slot_id]
		teacher_id = params[:teacher_id]
		noticeString = ""
		alertString = "Die Termin konnte nicht reserviert werden!"
		if slot_id != nil && teacher_id != nil
			Reservation.transaction do
				reservations = Reservation.where(event_id: getStudmanLoginEventId, slot_id: slot_id, teacher_id: teacher_id)
				if reservations.length != 0
					reservation = reservations[0]
					if reservation.student_id == nil
						# check to be added to make sure this student really is part of the team where this teacher is teaching
						check_reservations1 = Reservation.where(event_id: getStudmanLoginEventId, slot_id: slot_id, student_id: getStudmanLoginId)
						check_reservations2 = Reservation.where(event_id: getStudmanLoginEventId, teacher_id: teacher_id, student_id: getStudmanLoginId)
						student = Student.find(getStudmanLoginId)
						check_reservations3 = Teacherteam.where(event_id: getStudmanLoginEventId, teacher_id: teacher_id, team_id: student.team_id)
						if (check_reservations1.length == 0) && (check_reservations2.length == 0) && (check_reservations3.length > 0)
							reservation.student_id = getStudmanLoginId
							reservation.status = Reservation::RESERVATION_AVAILABILITY_BOOKED
							if reservation.save
								noticeString = "Der Termin konnte erfolgreich reserviert werden!"
								alertString = ""
							else
								raise ActiveRecord::Rollback
							end
						else
							raise ActiveRecord::Rollback
						end
					else
						raise ActiveRecord::Rollback
					end
				else
					raise ActiveRecord::Rollback
				end
			end
		end
		if alertString != ""
			flash.now[:alert] = alertString
		end
		if noticeString != ""
			flash.now[:notice] = noticeString
		end
		redirect_to action: 'manage_reservations'
	end

	def manage_reservations_reservation_cancel
		if !checkLogin
			return
		end

		if !checkRegDate
			redirect_to action: 'overview'
			return
		end

		reservation_id = params[:reservation_id]
		noticeString = ""
		alertString = "Die Reservation konnte nicht rückgängig gemacht werden!"
		if reservation_id != nil
			Reservation.transaction do
				reservations = Reservation.where(id: reservation_id)
				if reservations.length != 0
					reservation = reservations[0]
					if reservation.student_id == getStudmanLoginId
						reservation.student_id = nil
						reservation.status = Reservation::RESERVATION_AVAILABILITY_AVAILABLE
						if reservation.save
							noticeString = "Die Reservation konnte erfolgreich rückgängig gemacht werden!"
							alertString = ""
						else
							raise ActiveRecord::Rollback
						end
					else
						raise ActiveRecord::Rollback
					end
				else
					raise ActiveRecord::Rollback
				end
			end
		end
		if alertString != ""
			flash[:alert] = alertString
		end
		if noticeString != ""
			flash[:notice] = noticeString
		end
		redirect_to action: 'manage_reservations'
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
		get_slot_list_hash = temp_slot.getSlotList getStudmanLoginEventId, session[:slot_date]
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
		get_slot_list_hash = temp_slot.getSlotList getStudmanLoginEventId, session[:slot_date]
		slot_date = get_slot_list_hash[:slot_date]
		slot_list = get_slot_list_hash[:slot_list]

		printStudentReservations getStudmanLoginEventId, getStudmanLoginId, slot_date, slot_list
	end

	def logout
		noticeString = "Sie wurden erfolgreich abgemeldet!"
		redirect_to studman_login_path, notice: noticeString
	end

end
