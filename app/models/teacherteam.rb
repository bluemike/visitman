class Teacherteam < ActiveRecord::Base

	belongs_to :event
	belongs_to :teacher
	belongs_to :team

end
