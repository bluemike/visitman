class TeamsController < ApplicationController

	before_action :set_team, only: [:show, :edit, :update, :destroy]

	# GET /teams
	# GET /teams.json
	def index
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@teams = Team.all.order("id").paginate(page: params[:page], per_page: ROWSperPAGE)
	end

	# GET /teams/1
	# GET /teams/1.json
	def show
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

	end

	# GET /teams/new
	def new
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@team = Team.new
	end

	# GET /teams/1/edit
	def edit
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end

	end

	# POST /teams
	# POST /teams.json
	def create
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@team = Team.new(team_params)
		respond_to do |format|
			if @team.save
				if isLogin
					@team.changed_id = getLoginUserId
					@team.save
				end
				format.html { redirect_to @team, notice: 'Die Klasse wurde erfolgreich eröffnet.' }
				format.json { render :show, status: :created, location: @team }
			else
				format.html { render :new }
				format.json { render json: @team.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /teams/1
	# PATCH/PUT /teams/1.json
	def update
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		respond_to do |format|
			if @team.update(team_params)
				if isLogin
					@team.changed_id = getLoginUserId
					@team.save
				end
				format.html { redirect_to @team, notice: 'Die Klasse wurde erfolgreich gespeichert.' }
				format.json { render :show, status: :ok, location: @team }
			else
				format.html { render :edit }
				format.json { render json: @team.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /teams/1
	# DELETE /teams/1.json
	def destroy
		if !isLogin
			redirect_to controller: 'login', action: 'login'
			return
		end
		@team.destroy
		respond_to do |format|
			format.html { redirect_to teams_url, notice: 'Die Klasse wurde erfolgreich gelöscht.' }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_team
		@team = Team.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def team_params
		params.require(:team).permit(:title, :description)
	end
end

