class Teacher < ActiveRecord::Base

	SALT_VALUES = [["0","U"],["1","V"],["2","E"],["3","Y"],["4","Q"],["5","L"],["6","K"],["7","H"],["8","P"],["9","S"]]

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

end
