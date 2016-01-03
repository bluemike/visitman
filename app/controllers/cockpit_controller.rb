class CockpitController < ApplicationController

	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
	end

	def view_availabilities_slot_date_changed
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@slot_date = params[:view_availabilities][:slot_date]
		session[:slot_date] = @slot_date
		redirect_to action: 'view_availabilities'
	end

	def view_availabilities
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, session[:slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
		session[:slot_date] = @slot_date
		@teachers = Teacher.where(event_id: getLoginEventId).order(abbreviation: :asc)
	end

	def view_reservations_slot_date_changed
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@slot_date = params[:view_reservations][:slot_date]
		session[:slot_date] = @slot_date
		redirect_to action: 'view_reservations'
	end

	def view_reservations
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, session[:slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
		session[:slot_date] = @slot_date
		@teachers = Teacher.where(event_id: getLoginEventId).order(abbreviation: :asc)
	end

	def view_teacher_reservations_input_changed
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@teacher_id = params[:view_teacher_reservations][:teacher_id]
		session[:view_teacher_reservations_teacher_id] = @teacher_id
		@slot_date = params[:view_teacher_reservations][:slot_date]
		session[:view_teacher_reservations_slot_date] = @slot_date
		redirect_to action: 'view_teacher_reservations'
	end

	def view_teacher_reservations
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, session[:view_teacher_reservations_slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
		session[:view_teacher_reservations_slot_date] = @slot_date
		@teacher_id = session[:view_teacher_reservations_teacher_id]
		@teacher_list = getTeacherCollectionbyEventId(getLoginEventId)
		if @teacher_id == nil && @teacher_list.length > 0
			@teacher_id = @teacher_list[0][0]
		end
		session[:view_teacher_reservations_teacher_id] = @teacher_id
	end

	def print_teacher_reservations

		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

		teacher_id = session[:view_teacher_reservations_teacher_id]
		slot_date = session[:view_teacher_reservations_slot_date]
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, @slot_date
		slot_date = get_slot_list_hash[:slot_date]
		slot_list = get_slot_list_hash[:slot_list]

		printTeacherReservations getLoginEventId, teacher_id, slot_date, slot_list
	end


	def view_student_reservations_slot_date_changed
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@slot_date = params[:view_student_reservations][:slot_date]
		session[:view_student_reservations_slot_date] = @slot_date
		redirect_to action: 'view_student_reservations'
	end

	def view_student_reservations
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, session[:view_student_reservations_slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
		session[:view_student_reservations_slot_date] = @slot_date
		@student_id = params[:student_id]
		if @student_id == nil
			@student_id = session[:view_student_reservations_student_id]
		else
			session[:view_student_reservations_student_id] = @student_id
		end
	end

	def select_student_reservations
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

		@student_list = []
		@search_name = ""
		@search_firstname = ""
		@search_team_id = ""

		if request.post?

			name = params[:select_student_reservations][:name]
			@search_name = name
			firstname = params[:select_student_reservations][:firstname]
			@search_firstname = firstname
			team_id = params[:select_student_reservations][:team_id]
			@search_team_id = team_id

			if team_id == nil || team_id == ""
				@student_list = Student.where("event_id = ? AND name LIKE ? AND firstname LIKE ?", getLoginEventId, "%#{name}%", "%#{firstname}%").order(name: :asc, firstname: :asc)
			else
				team_id = team_id.to_i
				@student_list = Student.where("event_id = ? AND team_id = ? AND name LIKE ? AND firstname LIKE ?", getLoginEventId, team_id, "%#{name}%", "%#{firstname}%").order(name: :asc, firstname: :asc)
			end
		end

	end

	def print_student_reservations

		student_id = session[:view_student_reservations_student_id]
		slot_date = session[:view_student_reservations_slot_date]
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, slot_date
		slot_date = get_slot_list_hash[:slot_date]
		slot_list = get_slot_list_hash[:slot_list]

		printStudentReservations getLoginEventId, student_id, slot_date, slot_list
	end

	def view_teacher_room_reservations_slot_date_changed
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@slot_date = params[:view_teacher_room_reservations][:slot_date]
		session[:slot_date] = @slot_date
		redirect_to action: 'view_teacher_room_reservations'
	end

	def view_teacher_room_reservations
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, session[:slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
		session[:slot_date] = @slot_date
		@teachers = Teacher.where(event_id: getLoginEventId).order(abbreviation: :asc)
	end

	def print_teacher_room_reservations

		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, session[:slot_date]
		slot_date = get_slot_list_hash[:slot_date]
		slot_list = get_slot_list_hash[:slot_list]

		teachers = Teacher.where(event_id: getLoginEventId).order(abbreviation: :asc)
		event = Event.find(getLoginEventId)

		temp_slot = Slot.new
		eventString = event.title
		dateString = temp_slot.getNiceDateonlywithDayofWeekString(slot_date.to_date)
		titleString = "Zimmer-Belegungsplan"

		dataArray = []
		colorArray = []
		widthArray = []

		header_entry = ["Lehrkraft","Zimmer","Bemerkung", "Reservationen"]
		dataArray << header_entry
		colorArray << [nil, nil, nil, nil]
		widthArray << [nil, nil, nil, nil]

		teachers.each do |teacher|

			firstnamename = "%s %s (%s)" % [teacher.firstname, teacher.name, teacher.abbreviation]

			room_comment = teacher.getRoomComment
			room_status = teacher.getRoomStatus
			room_status_color = teacher.getRoomStatusPrintColor room_status

			numreservations = 0

			slot_list.each do |slot|
	       		reservations = Reservation.where(event_id: getLoginEventId, slot_id: slot.id, teacher_id: teacher.id)
				if reservations.length > 0
					if reservations[0].student_id != nil
						numreservations += 1
					end
				end
			end

			reservation_description = numreservations > 0 ? "%d Reservationen" : "keine Reservationen"
			tempreservation = Reservation.new
			reservation_status = numreservations > 0 ? Reservation::RESERVATION_AVAILABILITY_BOOKED : Reservation::RESERVATION_AVAILABILITY_NOT_AVAILABLE
			reservation_status_color = tempreservation.getReservationAvailabilityPrintColor reservation_status

			dataArray << [firstnamename, teacher.room_title, room_comment, reservation_description]
			colorArray << [nil, room_status_color, nil, reservation_status_color]

		end

		displayPDF eventString, dateString, titleString, dataArray, colorArray, widthArray

	end


end

