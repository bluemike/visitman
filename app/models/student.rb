class Student < ActiveRecord::Base

	SALT_VALUES = [["0","M"],["1","X"],["2","B"],["3","U"],["4","R"],["5","F"],["6","Z"],["7","G"],["8","L"],["9","D"]]
	SALT_BASE_VALUE = 13680

	belongs_to :event
	belongs_to :team

	require 'csv'

	def self.to_csv
		(CSV.generate(col_sep: ';', row_sep: "\n", headers: false) do |csv|
			col_names = ["id","name","firstname","code","team.title"]
			csv << col_names
			all.each do |student|
				team = Team.find(student.team_id)
				csv << [student.id,student.name,student.firstname,student.code,team.title]
			end
		end).encode('WINDOWS-1252', :undef => :replace, :replace => '')
	end

	def checkStudentLogin loginevent_id, loginCode, loginTeam, loginFirstname
		student = Student.where(event_id: loginevent_id, code: loginCode, firstname: loginFirstname)
		if student.length > 0
			team = Team.where(title: loginTeam)
			if team.length > 0
				return student[0]

			end
		end
		return nil
	end

	def getCode

		require 'securerandom'

		identifier = "S"
		code = ""
		5.times do
			code << SALT_VALUES[SecureRandom.random_number(10)][1]
		end
		return "%s-%s" % [identifier, code]
	end

end
