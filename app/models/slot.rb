class Slot < ActiveRecord::Base

	DAY_OF_WEEK_VALUES = [[0, "Sonntag"], [1, "Montag"], [2, "Dienstag"], [3, "Mittwoch"], [4, "Donnerstag"], [5, "Freitag"], [6, "Samstag"], [7, ""]]

	belongs_to :event

	def getNiceDateonlywithDayofWeekString(value)
		day_of_week_string = ""
		if value != nil
			DAY_OF_WEEK_VALUES.each do |num, dow_string|
				if num == value.wday
					day_of_week_string = dow_string
				end
			end
			return "%s, %s" % [day_of_week_string, value.strftime("%d.%m.%Y")]
		end
		return "n/a"
	end

	def getSlotList event_id, slot_date = nil
		get_slot_list_hash = []
		start_datetime = nil
		last_datetime = nil
		slot_datelist = []
		slot_list = []
		temp_slots = Slot.where(event_id: event_id).order(slot_date: :asc)
		temp_slots.each do |slot|
			start_datetime = slot.from_time
			if last_datetime == nil || last_datetime.to_date != start_datetime.to_date
				if slot_date == nil
					slot_date = start_datetime.to_date
				end
				slot_date_entry = [getNiceDateonlywithDayofWeekString(start_datetime), start_datetime.to_date]
				slot_datelist << slot_date_entry
				last_datetime = start_datetime
			end
			if slot_date.to_date == start_datetime.to_date
				slot_list << slot
			end
		end
		get_slot_list_hash = {slot_date: slot_date, slot_list: slot_list, slot_datelist: slot_datelist}
		return get_slot_list_hash
	end


end
