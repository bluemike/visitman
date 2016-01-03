class Teacher < ActiveRecord::Base

	SALT_VALUES = [["0","U"],["1","V"],["2","E"],["3","Y"],["4","Q"],["5","L"],["6","K"],["7","H"],["8","P"],["9","S"]]

	TEACHER_ROOM_OK = 0
	TEACHER_ROOM_UNDEFINED = -1
	TEACHER_ROOM_MULTIPLE = 1

	belongs_to :event
	belongs_to :team

	require 'csv'

	def self.to_csv
		(CSV.generate(col_sep: ';', row_sep: "\n", headers: false) do |csv|
			col_names = ["id","name","firstname","code","room"]
			csv << col_names
			all.each do |teacher|
				csv << [teacher.id,teacher.name,teacher.firstname,teacher.code,teacher.room_title]
			end
		end).encode('WINDOWS-1252', :undef => :replace, :replace => '')
	end

	def checkTeacherLogin loginevent_id, loginCode, loginFirstname
		teacher = Teacher.where(event_id: loginevent_id, code: loginCode, firstname: loginFirstname)
		if teacher.length > 0
			return teacher[0]
		end
		return nil
	end

	def getTeamTitle
		title = "n/a"
		teams = Team.where(id: self.team_id)
		if teams.length > 0
			title = teams[0].title
		end
		return title
	end

	def getCode

		require 'securerandom'

		identifier = "T"
		code = ""
		6.times do
			code << SALT_VALUES[SecureRandom.random_number(10)][1]
		end
		return "%s-%s" % [identifier, code]
	end

	def getRoomStatus

		if room_title == nil || room_title == ""
			return TEACHER_ROOM_UNDEFINED
		end
		teacher_list = Teacher.where(event_id: event_id)

		multiple = false
		teacher_list.each do |teacher|
			if teacher.id != id && teacher.room_title == room_title
				multiple = true
			end
		end
		status = multiple ? TEACHER_ROOM_MULTIPLE : TEACHER_ROOM_OK
		return status

	end

	def getRoomComment

		comment = ""

		if room_title == nil || room_title == ""
			return comment
		end
		teacher_list = Teacher.where(event_id: event_id)

		teacher_room_multiple = false
		teacher_list.each do |teacher|
			if teacher.id != id && teacher.room_title == room_title
				multiple = true
				if comment == ""
					comment = "%s" % [teacher.abbreviation]
				else
					comment = "%s, %s" % [comment, teacher.abbreviation]
				end
			end
		end

		return comment

	end

	def getRoomStatusColor status
		color = "active"
		if status == TEACHER_ROOM_OK
			color = "success"
		elsif status == TEACHER_ROOM_UNDEFINED
			color = "danger"
		elsif status == TEACHER_ROOM_MULTIPLE
			color = "warning"
		end
		return color
	end

	def getRoomStatusPrintColor status

		color = "FFFFFF"
		if status == TEACHER_ROOM_OK
			color = "DFF0D8"
		elsif status == TEACHER_ROOM_UNDEFINED
			color = "F2DEDE"
		elsif status == TEACHER_ROOM_MULTIPLE
			color = "F0AD4E"
		end
		return color

	end

end
