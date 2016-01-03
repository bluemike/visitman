class Reservation < ActiveRecord::Base

	RESERVATION_AVAILABILITY_VALUES = [["nicht verfügbar", -1], ["offen", 0], ["verfügbar", 1]]

	RESERVATION_AVAILABILITY_NOT_AVAILABLE = -1
	RESERVATION_AVAILABILITY_OPEN = 0
	RESERVATION_AVAILABILITY_AVAILABLE = 1
	RESERVATION_AVAILABILITY_BOOKED = 99


	belongs_to :event
	belongs_to :teacher
	belongs_to :slot
	belongs_to :student


	def getReservationAvailability event_id, teacher_id, slot_id
		status = RESERVATION_AVAILABILITY_OPEN
		reservation = Reservation.where(event_id: event_id, teacher_id: teacher_id, slot_id: slot_id)
		if reservation.length > 0
			status = reservation[0].status
		end
		return status
	end

	def getReservationAvailabilityColor status
		color = "active"
		if status == RESERVATION_AVAILABILITY_AVAILABLE
			color = "success"
		elsif status == RESERVATION_AVAILABILITY_NOT_AVAILABLE
			color = "danger"
		elsif status == RESERVATION_AVAILABILITY_BOOKED
			color = "info"
		end
		return color
	end

	def getReservationAvailabilityPrintColor status
		if status == RESERVATION_AVAILABILITY_AVAILABLE
			color = "DFF0D8"
		elsif status == RESERVATION_AVAILABILITY_NOT_AVAILABLE
			color = "F2DEDE"
		elsif status == RESERVATION_AVAILABILITY_BOOKED
			color = "D9EDF7"
		end
		return color
	end

end
