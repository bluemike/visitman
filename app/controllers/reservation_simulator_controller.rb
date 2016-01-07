class ReservationSimulatorController < ApplicationController

	def index

		@max_availabilities = session[:reservation_simulator_max_availabilities]
		if session[:reservation_simulator_max_availabilities] == nil
			@reservation_simulator_max_availabilities = 80
		end

		@max_reservations = session[:reservation_simulator_max_reservations]
		if session[:reservation_simulator_max_reservations] == nil
			@reservation_simulator_max_reservations = 40
		end
		render "reservation_simulator"
	end

	def checkSimulatorEntry teacher_id, student_id
		if student_id == nil
			return true
		end
		student = Student.find(student_id)
		team = Team.find(student.team)
		teacherteams = Teacherteam.where(teacher_id: teacher_id, team_id: team.id)
		if teacherteams.length == 0
			return false
		end
		return true
	end

	def execute

		require 'securerandom'

		reservations = Reservation.where(event_id: getLoginEventId)
		reservations.destroy_all

		@max_availabilities = params[:reservation_simulator][:max_availabilities]
		session[:reservation_simulator_max_availabilities] = @max_availabilities
		@max_reservations = params[:reservation_simulator][:max_reservations]
		session[:reservation_simulator_max_reservations] = @max_reservations

		@max_availabilities = @max_availabilities.to_i
		@max_reservations = @max_reservations.to_i

		num_availabilities = 0
		num_reservations = 0

		slots = Slot.where(event_id: getLoginEventId)
		slots.each do |slot|

			teachers = Teacher.where(event_id: getLoginEventId)
			teachers.each do |teacher|

				reservations = Reservation.where(event_id: getLoginEventId, teacher_id: teacher.id, slot_id: slot.id)
				if (reservations.length > 0)
					reservation = reservations[0]
				else
					reservation = Reservation.new
					reservation.teacher_id = teacher.id
					reservation.slot_id = slot.id
					reservation.event_id = getLoginEventId
					reservation.changed_id = getLoginUserId
					reservation.student_id = nil
					random_percentage = SecureRandom.random_number(100)
					if (random_percentage <= @max_availabilities)
						reservation.status = Reservation::RESERVATION_AVAILABILITY_AVAILABLE
					else
						reservation.status = Reservation::RESERVATION_AVAILABILITY_NOT_AVAILABLE
					end
				end
				if reservation.status == Reservation::RESERVATION_AVAILABILITY_AVAILABLE
					random_percentage = SecureRandom.random_number(100)
					if (random_percentage <= @max_reservations)
						teacherteams = Teacherteam.where(event_id: getLoginEventId, teacher_id: teacher.id)
						if teacherteams.length != 0
							random_teacherteam_index = SecureRandom.random_number(teacherteams.length)
							teacherteam = teacherteams[random_teacherteam_index]
							students = Student.where(event_id: getLoginEventId, team_id: teacherteam.team_id)
							students.shuffle
							students.each do |student|
								check_reservations1 = Reservation.where(event_id: getLoginEventId, teacher_id: teacher.id, student_id: student.id)
								check_reservations2 = Reservation.where(event_id: getLoginEventId, slot_id: slot.id, student_id: student.id)
								check_reservations3 = Reservation.where(event_id: getLoginEventId, slot_id: slot.id, teacher_id: teacher.id)
								if (check_reservations1.length == 0) && (check_reservations2.length == 0) && (check_reservations3.length == 0)
									reservation.student_id = student.id
									reservation.status = Reservation::RESERVATION_AVAILABILITY_BOOKED
									break
								end
							end
						end
					end
				end
				if !checkSimulatorEntry(reservation.teacher_id, reservation.student_id)
					i = i + 1
				end
				if reservation.save
					num_availabilities += 1
					if reservation.student_id != nil
						num_reservations += 1
					end
				end
			end
		end

		noticeString = "Es wurden %d Verfügbarkeiten und %d Reservationen erfolgreich generiert!" % [num_availabilities, num_reservations]
		flash[:notice] = noticeString

		redirect_to "/reservation_simulator/index"

	end
end