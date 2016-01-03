class TeachersController < ApplicationController

	before_action :set_teacher, only: [:show, :edit, :update, :destroy]

	# GET /teachers
	# GET /teachers.json
	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@teachers = Teacher.all.order("id").paginate(page: params[:page], per_page: ROWSperPAGE)
	end

	# GET /teachers/1
	# GET /teachers/1.json
	def show
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

	end

	# GET /teachers/new
	def new
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@teacher = Teacher.new
	end

	# GET /teachers/1/edit
	def edit
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

	end

	# POST /teachers
	# POST /teachers.json
	def create
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@teacher = Teacher.new(teacher_params)
		respond_to do |format|
			if @teacher.save
				if isLogin
					@teacher.code = @teacher.getCode
					@teacher.changed_id = getLoginUserId
					@teacher.save
				end
				format.html { redirect_to @teacher, notice: 'Der Lehrer wurde erfolgreich eröffnet.' }
				format.json { render :show, status: :created, location: @teacher }
			else
				format.html { render :new }
				format.json { render json: @teacher.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /teachers/1
	# PATCH/PUT /teachers/1.json
	def update
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		respond_to do |format|
			if @teacher.update(teacher_params)
				if isLogin
					@teacher.changed_id = getLoginUserId
					@teacher.save
				end
				format.html { redirect_to @teacher, notice: 'Der Lehrer wurde erfolgreich gespeichert.' }
				format.json { render :show, status: :ok, location: @teacher }
			else
				format.html { render :edit }
				format.json { render json: @teacher.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /teachers/1
	# DELETE /teachers/1.json
	def destroy
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@teacher.destroy
		respond_to do |format|
			format.html { redirect_to teachers_url, notice: 'Der Lehrer wurde erfolgreich gelöscht.' }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_teacher
		@teacher = Teacher.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def teacher_params
		params.require(:teacher).permit(:name, :firstname, :abbreviation, :email, :room_title, :team_id)
	end
end

