class SlotsController < ApplicationController

	def slot_date_changed
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@slot_date = params[:slot][:slot_date]
		session[:slot_date] = @slot_date
		redirect_to action: 'show'
	end

	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		event = Event.find(getLoginEventId)
		@slot_start_String = ConvertToDateString(event.is_from_date)
		@slot_end_String = ConvertToDateString(event.is_to_date)
		@slot_duration_String = event.default_slot_duration
		redirect_to action: 'show'
	end

	def show
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		temp_slot = Slot.new
		get_slot_list_hash = temp_slot.getSlotList getLoginEventId, session[:slot_date]
		@slot_date = get_slot_list_hash[:slot_date]
		@slot_list = get_slot_list_hash[:slot_list]
		@slot_datelist = get_slot_list_hash[:slot_datelist]
	end

	def delete_all_slots
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		Slot.delete_all(["event_id = ?", getLoginEventId])
		flash[:alert] = "Es wurden alle Slots erfolgreich gelöscht!"
		redirect_to action: 'show'

	end

	def create_slot_group
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

		@slot_start_String = params["slot"]["slot_start_datetime"].to_s
		@slot_end_String = params["slot"]["slot_end_datetime"].to_s
		@slot_duration_String = params["slot"]["slot_duration"].to_s

		start_datetime = ConvertToDate(@slot_start_String)
		end_datetime = ConvertToDate(@slot_end_String)
		duration = @slot_duration_String.to_i

		num_slots = 0

		while start_datetime < end_datetime do
			slot = Slot.new
			slot.event_id = getLoginEventId
			slot.slot_date = start_datetime
			slot.from_time = start_datetime
			slot.to_time = start_datetime + duration.minutes

			if slot.save
				num_slots = num_slots + 1
			else
				flash[:alert] = "Die Slots konnten nicht wunschgemäss generiert werden!"
				redirect_to action: 'show'
			end

			start_datetime = start_datetime + duration.minutes

		end

		noticeString = "Es wurden %d Slots erfolgreich generiert!" % [num_slots]
		flash[:notice] = noticeString
		redirect_to action: 'show'

	end

end

