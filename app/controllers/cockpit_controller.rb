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
		@teacher_id = session[:view_teacher_reservations_teacher_id]
		@slot_date = session[:view_teacher_reservations_slot_date]
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, @slot_date
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]

		pdf = Prawn::Document.new

		pdf.image "#{Rails.root}/app/assets/images/schoolfrick.png", at: [0,750]
		pdf.draw_text "Elterngespräche 2015", size: 24, style: :bold, at: [250,680]

		teacher = Teacher.find(@teacher_id)

		pdf.move_down 80
		temp_slot = Slot.new
		pdf.text "%s" % [temp_slot.getNiceDateonlywithDayofWeekString(@slot_date.to_date)], size: 16, style: :bold
		pdf.text "%s %s (%s) im Zimmer %s" % [teacher.firstname, teacher.name, teacher.abbreviation, teacher.room_title], size: 16, style: :bold
		pdf.move_down 40

		data = []
		reservation_status = []

        header_entry = ["von","bis","Reservation"]
        data << header_entry
		reservation_status << "nil"

        last_to_datetime = nil
        @slot_list.each do |slot|
            from_datetime = slot.from_time
            to_datetime = slot.to_time

            if last_to_datetime != nil && last_to_datetime!= from_datetime

            end
            last_to_datetime = to_datetime

            temp_reservation = Reservation.new
            reservations = Reservation.where(event_id: getLoginEventId, teacher_id: @teacher_id, slot_id: slot.id)
            student_string = ""
            if reservations.length > 0
	            reservation = reservations[0]
	            status = reservation.status
	            if reservation.student_id != nil
		            student = Student.find(reservation.student_id)
		            team = Team.find(student.team_id)
		            student_string = "%s %s (%s)" % [student.firstname, student.name, team.title]
					status = Reservation::RESERVATION_AVAILABILITY_BOOKED
	            end
				reservation_status << status
            end

            row_entry = []
	        row_entry << getNiceTimeString(from_datetime)
	        row_entry << getNiceTimeString(to_datetime)
	        row_entry << student_string
	        data << row_entry

        end

		pdf.table data do
			style(row(0), font_style: :bold)
			style(column(2), font_style: :bold)
			i = 0
			while i < row_length  do
				if i == 0
					style(row(i), background_color: "FFFFFF")
				else
					if i.odd?
						style(row(i), background_color: "F0F0F0")
					end
					temp_reservation = Reservation.new
					style(row(i).column(2), background_color: temp_reservation.getReservationAvailabilityPrintColor(reservation_status[i]))
				end
				i += 1
			end
		end

		send_data pdf.render, :filename => "x.pdf", :type => "application/pdf"

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



end

