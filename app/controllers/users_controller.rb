class UsersController < ApplicationController

	before_action :set_user, only: [:show, :edit, :update, :destroy]

	# GET /users
	# GET /users.json
	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@users = User.all.order("id").paginate(page: params[:page], per_page: ROWSperPAGE)
	end

	# GET /users/1
	# GET /users/1.json
	def show
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

	end

	# GET /users/new
	def new
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@user = User.new
	end

	# GET /users/1/edit
	def edit
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

	end

	# POST /users
	# POST /users.json
	def create
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@user = User.new(user_params)
		respond_to do |format|
			if @user.save
				if isLogin
					@user.changed_id = getLoginUserId
					@user.save
				end
				format.html { redirect_to @user, notice: 'Der Benutzer wurde erfolgreich eröffnet.' }
				format.json { render :show, status: :created, location: @user }
			else
				format.html { render :new }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /users/1
	# PATCH/PUT /users/1.json
	def update
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		respond_to do |format|
			if @user.update(user_params)
				if isLogin
					@user.changed_id = getLoginUserId
					@user.save
				end
				format.html { redirect_to @user, notice: 'Der Benutzer wurde erfolgreich gespeichert.' }
				format.json { render :show, status: :ok, location: @user }
			else
				format.html { render :edit }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.json
	def destroy
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@user.destroy
		respond_to do |format|
			format.html { redirect_to users_url, notice: 'Der Benutzer wurde erfolgreich gelöscht.' }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_user
		@user = User.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def user_params
		params.require(:user).permit(:email, :password, :name, :firstname, :address, :zip, :place, :country, :mobile, :sex, :role_type, :active)
	end
end

