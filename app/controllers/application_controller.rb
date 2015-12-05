class ApplicationController < ActionController::Base
	# force_ssl if: :ssl_configured?

	TIMEOUTforLOGIN = 300

	helper_method :ConvertToDate, :ConvertToDateString, :getNiceDateString, :getNiceDateonlyString, :getNiceTimeString
	helper_method :checkLogin, :isLogin, :getLoginUserId, :getLoginNameString, :getLoginFirstNameString, :getLoginRoleType, :getLoginRoleTypeValue
	helper_method :isLoginRoleType, :selectedEvent, :getLoginEventString, :getLoginEventId, :getPreviousLoginValue
	helper_method :getEventCollectionbyStatus, :getTeamCollectionbyEventId, :getTeacherCollectionbyEventId

	helper_method :isTeachmanLogin, :getTeachmanLoginId, :getTeachmanLoginEventId, :getTeachmanLoginEventString, :getTeachmanLoginFirstnameNameString, :getTeachmanTeamTeacher, :getTeachmanLoginRoomString
	helper_method :isStudmanLogin, :getStudmanLoginId, :getStudmanLoginEventId, :getStudmanLoginEventString, :getStudmanLoginFirstnameNameString, :getStudmanTeamId, :getStudmanTeamString

	helper_method :checkStudmanLogin, :checkTeachmanLogin

	def ssl_configured?
		!Rails.env.development?
	end

	def checkStudmanLogin
		if session[:student_id] != nil
			lastlogin = session[:lastlogin]
			tfl = TIMEOUTforLOGIN
			tn = Time.now
			timediff = (tn - lastlogin).to_i

			if lastlogin == nil || (timediff > tfl)
				return false
			end
		else
			return false
		end
		session[:lastlogin] = Time.now
		return true
	end

	def checkTeachmanLogin
		if session[:teacher_id] != nil
			lastlogin = session[:lastlogin]
			tfl = TIMEOUTforLOGIN
			tn = Time.now
			timediff = (tn - lastlogin).to_i

			if lastlogin == nil || (timediff > tfl)
				return false
			end
		else
			return false
		end
		session[:lastlogin] = Time.now
		return true
	end

	def isStudmanLogin
		if session[:student_id] != nil
			return true
		end
		return false
	end

	def getStudmanLoginId
		if session[:student_id] != nil
			return session[:student_id]
		end
		return -1
	end

	def getStudmanLoginEventId
		if isStudmanLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.id
			end
		end
		return -1
	end

	def getStudmanLoginEventString
		if isStudmanLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.title
			end
		end
		return "n/a"
	end

	def getStudmanLoginFirstnameNameString
		if isStudmanLogin
			return "%s %s" % [session[:student_firstname], session[:student_name]]
		end
		return "n/a"
	end

	def getStudmanTeamId
		if session[:team_id] != nil
			return session[:team_id]
		end
		return -1
	end

	def getStudmanTeamString
		if session[:team_id] != nil
			team = Team.find(session[:team_id])
			return team.title
		end
		return "n/a"
	end

	def isTeachmanLogin
		if session[:teacher_id] != nil
			return true
		end
		return false
	end

	def getTeachmanLoginId
		if session[:teacher_id] != nil
			return session[:teacher_id]
		end
		return -1
	end

	def getTeachmanLoginEventId
		if isTeachmanLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.id
			end
		end
		return -1
	end

	def getTeachmanLoginEventString
		if isTeachmanLogin
			if session[:event_id] != nil
				loginevent = Event.find(session[:event_id])
				return loginevent.title
			end
		end
		return "n/a"
	end

	def getTeachmanLoginRoomString
		if isTeachmanLogin
			return session[:teacher_room_title]
		end
		return "n/a"
	end

	def getTeachmanLoginFirstnameNameString
		if isTeachmanLogin
			return "%s %s" % [session[:teacher_firstname], session[:teacher_name]]
		end
		return "n/a"
	end

	def getTeachmanTeamTeacher
		teacher_id = getTeachmanLoginId
		if teacher_id != -1
			teachers = Teacher.where(id: teacher_id)
			if teachers != nil
				teacher = teachers[0]
				if teacher.team_id != nil
					teams = Team.where(id: teacher.team_id)
					if teams != nil
						return teacher.team_id
					end
				end
			end
			return -1
		end
	end

	def ConvertToDate(value)
		convertdate = Time.zone.parse(value)
		return convertdate
	end

	def ConvertToDateString(value)
		return getNiceDateString(value)
	end

	def getNiceDateString(value)
		if value != nil
			return value.strftime("%d.%m.%Y %H:%M")
		end
		return "n/a"
	end

	def getNiceDateonlyString(value)
		if value != nil
			return value.strftime("%d.%m.%Y")
		end
		return "n/a"
	end

	def getNiceTimeString(value)
		if value != nil
			return value.strftime("%H:%M")
		end
		return "n/a"
	end

	def checkLogin (email, password)
        loginuser = User.find_by email: email
        if loginuser!=nil && loginuser.password == password
            return loginuser
        end
        return nil
	end

    def isLogin
        if session[:user_id] != nil
            return true
        end
        return false
	end

	def getLoginUserId
        if isLogin
            return session[:user_id]
        end
        return "n/a"
    end

    def getLoginNameString
        if isLogin
            return session[:user_name]
        end
        return "n/a"
	end

	def getLoginFirstNameString
        if isLogin
            return session[:user_firstname]
        end
        return "n/a"
	end

    def getLoginRoleType
        if isLogin
            return session[:user_role_type]
        end
        return 0
    end

	def getLoginRoleTypeValue
        if isLogin
            newuser = User.new
        return newuser.getRoleTypeValue(session[:user_role_type])
        end
        return "n/a"
    end

	def isLoginRoleType (reference_role_type)
        if isLogin
            if session[:user_role_type] == reference_role_type
                return true
            end
        end
        return false
    end

	def selectedEvent
        if isLogin
            if session[:event_id] != nil
                return true
            end
        end
        return false
	end

	def getLoginEventId
        if isLogin
            if session[:event_id] != nil
                loginevent = Event.find(session[:event_id])
                return loginevent.id
            end
        end
        return -1
    end

	def getLoginEventString
        if isLogin
            if session[:event_id] != nil
                loginevent = Event.find(session[:event_id])
                return loginevent.title
            end
        end
        return "n/a"
	end

	def getPreviousLoginValue
		if isLogin
			if session[:previous_login] != nil
				return session[:previous_login]
			end
        end
        return Time.now
    end

	def getEventCollectionbyStatus(value)
        return Event.where("active=%s",value).all
    end

	def getTeamCollectionbyEventId(event_id)
		return Team.where("event_id=%d",event_id).all
	end

	def getTeacherCollectionbyEventId(event_id)
		teachers = Teacher.where("event_id=%d",event_id).order(abbreviation: :asc)
		teacher_list = []
		teachers.each do |teacher|
			teacher_string = "%s %s (%s)" % [teacher.firstname, teacher.name, teacher.abbreviation]
			teacher_entry = [teacher_string,teacher.id]
			teacher_list << teacher_entry
		end
		return teacher_list
	end

	protect_from_forgery

#private
#	def doLoginAndSessionCheck
#		if isLogin
#			if session[:last_seen] < 10.minute.ago
#				session[:last_seen] = Time.now
#				return
#			end
#		end
#		redirect_to controller: 'login', action: 'login'
#	end

end

