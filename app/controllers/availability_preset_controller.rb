class AvailabilityPresetController < ApplicationController

	def index
		render "availability_preset"
	end

	def execute

		num_availabilities = 0

		slots = Slot.where(event_id: getLoginEventId)
		slots.each do |slot|

			teachers = Teacher.where(event_id: getLoginEventId)
			teachers.each do |teacher|


				reservation_list = Reservation.where(event_id: getLoginEventId, slot_id: slot.id, teacher_id: teacher.id)
				if reservation_list.length > 0
					reservation = reservation_list[0]
				else
					reservation = Reservation.new
					reservation.teacher_id = teacher.id
					reservation.slot_id = slot.id
					reservation.event_id = getLoginEventId
					reservation.status = Reservation::RESERVATION_AVAILABILITY_OPEN
				end

				reservation.changed_id = getLoginUserId

				if reservation.status == Reservation::RESERVATION_AVAILABILITY_OPEN

					reservation.status = Reservation::RESERVATION_AVAILABILITY_AVAILABLE
					reservation.save
					num_availabilities += 1

				end

			end

		end

		noticeString = "Es wurden %d Verfügbarkeiten gesetzt!" % [num_availabilities]
		flash[:notice] = noticeString

		redirect_to "/availability_preset/index"

	end
end