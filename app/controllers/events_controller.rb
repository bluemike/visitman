class EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
	  if !isLogin
		  redirect_to controller: 'login', action: 'login'
		  return
	  end
    @events = Event.all.paginate(page: params[:page], per_page: ROWSperPAGE)
  end

  # GET /events/1
  # GET /events/1.json
  def show
	  if !isLogin
		  redirect_to controller: 'login', action: 'login'
		  return
	  end

  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit

  end

  # POST /events
  # POST /events.json
  def create
	  if !isLogin
		  redirect_to controller: 'login', action: 'login'
		  return
	  end
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        if isLogin
          @event.changed_id = getLoginUserId
          @event.save
        end
        format.html { redirect_to @event, notice: 'Der Event wurde erfolgreich eröffnet.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
	  if !isLogin
		  redirect_to controller: 'login', action: 'login'
		  return
	  end
	  respond_to do |format|
	    if @event.update(event_params)
        if isLogin
          @event.changed_id = getLoginUserId
          @event.save
        end

        format.html { redirect_to @event, notice: 'Der Event wurde erfolgreich gespeichert.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
	  if !isLogin
		  redirect_to controller: 'login', action: 'login'
		  return
	  end
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Der Event wurde erfolgreich gelöscht.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :is_from_date, :is_to_date, :teacher_reg_from_date, :teacher_reg_to_date, :student_reg_from_date, :student_reg_to_date, :default_game_duration, :default_slot_duration, :active)
  end
end

