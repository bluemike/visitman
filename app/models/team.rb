class Team < ActiveRecord::Base

	belongs_to :event

	def find_by_title(event_id, team_title)
		team = nil
		teams = Team.where(event_id: event_id, title: team_title)
		if teams.length > 0
			team = teams[0]
		end
		return team
	end

	def self.find_by_title(event_id, team_title)
		team = nil
		teams = Team.where(event_id: event_id, title: team_title)
		if teams.length > 0
			team = teams[0]
		end
		return team
	end

end
