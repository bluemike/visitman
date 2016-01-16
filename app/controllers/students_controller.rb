class StudentsController < ApplicationController

	before_action :set_student, only: [:show, :edit, :update, :destroy]

	# GET /students
	# GET /students.json
	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@students = Student.all.order("id").includes(:team).paginate(page: params[:page], per_page: ROWSperPAGE)
	end

	# GET /students/1
	# GET /students/1.json
	def show
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

	end

	# GET /students/new
	def new
		if !isLogin
			redirect_to controller: 'login', action: 'login'
		end
		@student = Student.new
	end

	# GET /students/1/edit
	def edit
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

	end

	# POST /students
	# POST /students.json
	def create
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@student = Student.new(student_params)
		respond_to do |format|
			if @student.save
				if isLogin
					@student.code = @student.getCode
					@student.event_id = getLoginEventId
					@student.changed_id = getLoginUserId
					@student.save
				end
				format.html { redirect_to @student, notice: 'Der Schüler wurde erfolgreich eröffnet.' }
				format.json { render :show, status: :created, location: @student }
			else
				format.html { render :new }
				format.json { render json: @student.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /students/1
	# PATCH/PUT /students/1.json
	def update
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		respond_to do |format|
			if @student.update(student_params)
				if isLogin
					@student.changed_id = getLoginUserId
					@student.save
				end
				format.html { redirect_to @student, notice: 'Der Schüler wurde erfolgreich gespeichert.' }
				format.json { render :show, status: :ok, location: @student }
			else
				format.html { render :edit }
				format.json { render json: @student.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /students/1
	# DELETE /students/1.json
	def destroy
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@student.destroy
		respond_to do |format|
			format.html { redirect_to students_url, notice: 'Der Schüler wurde erfolgreich gelöscht.' }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_student
		@student = Student.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def student_params
		params.require(:student).permit(:name, :firstname, :email, :team_id)
	end
end

