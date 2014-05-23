class RoundUpTimesController < ApplicationController
  # GET /round_up_times
  # GET /round_up_times.json
  before_filter :authorize_admin
  def index
    @round_up_times = RoundUpTime.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @round_up_times }
    end
  end

  # GET /round_up_times/1
  # GET /round_up_times/1.json
  def show
    @round_up_time = RoundUpTime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @round_up_time }
    end
  end

  # GET /round_up_times/new
  # GET /round_up_times/new.json
  def new
    @round_up_time = RoundUpTime.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @round_up_time }
    end
  end

  # GET /round_up_times/1/edit
  def edit
    @round_up_time = RoundUpTime.find(params[:id])
  end

  # POST /round_up_times
  # POST /round_up_times.json
  def create
    @round_up_time = RoundUpTime.new(params[:round_up_time])

    respond_to do |format|
      if @round_up_time.save
        format.html { redirect_to @round_up_time, notice: 'Round up time was successfully created.' }
        format.json { render json: @round_up_time, status: :created, location: @round_up_time }
      else
        format.html { render action: "new" }
        format.json { render json: @round_up_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /round_up_times/1
  # PUT /round_up_times/1.json
  def update
    @round_up_time = RoundUpTime.find(params[:id])

    respond_to do |format|
      if @round_up_time.update_attributes(params[:round_up_time])
        format.html { redirect_to @round_up_time, notice: 'Round up time was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @round_up_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /round_up_times/1
  # DELETE /round_up_times/1.json
  def destroy
    @round_up_time = RoundUpTime.find(params[:id])
    @round_up_time.destroy

    respond_to do |format|
      format.html { redirect_to round_up_times_url }
      format.json { head :no_content }
    end
  end
end
