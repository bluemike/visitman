class LoginController < ApplicationController

	# skip_before_filter :doLoginAndSessionCheck, except: [:index, :login]

	def index
        redirect_to action: 'login'
    end

    def login

	    reset_session

	    if request.post?

	        loginEmail = params[:login][:loginEmail]
	        loginPassword = params[:login][:loginPassword]
	        loginevent_id = params[:login][:loginevent_id]

			loginuser = checkLogin(loginEmail, loginPassword)
			if loginuser != nil
		        noticeString = "Anmeldung mit Email: %s war erfolgreich!" % [loginEmail]
		        session[:user_id] = loginuser.id
		        session[:user_email] = loginuser.email
		        session[:user_name] = loginuser.name
		        session[:user_firstname] = loginuser.firstname
		        session[:user_role_type] = loginuser.role_type
		        session[:event_id] = loginevent_id
		        session[:previous_login] = loginuser.last_login_at
		        session[:last_seen] = Time.now
		        loginuser.update_columns(:last_login_at => Time.now)

		        redirect_to cockpit_path, notice: noticeString
	        elsif
		        alertString = "Anmeldung mit Email: %s war NICHT erfolgreich!" % [loginEmail]
		        redirect_to login_path, alert: alertString
	        end
		end
  
	end

  def logout
    noticeString = "Sie wurden erfolgreich abgemeldet!"
    redirect_to login_path, notice: noticeString
  end

end
