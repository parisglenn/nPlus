class UserOfficeHoursController < ApplicationController
  # GET /user_office_hours
  # GET /user_office_hours.json
  def index
    @user_office_hours = UserOfficeHour.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_office_hours }
    end
  end

  # GET /user_office_hours/1
  # GET /user_office_hours/1.json
  def show
    @user_office_hour = UserOfficeHour.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_office_hour }
    end
  end

  # GET /user_office_hours/new
  # GET /user_office_hours/new.json
  def new
    @user_office_hour = UserOfficeHour.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_office_hour }
    end
  end

  # GET /user_office_hours/1/edit
  def edit
    @user_office_hour = UserOfficeHour.find(params[:id])
  end

  # POST /user_office_hours
  # POST /user_office_hours.json
  def create
    params[:user_office_hour][:user_id] = current_user.id 
    @user_office_hour = UserOfficeHour.new(params[:user_office_hour])

    respond_to do |format|
      if @user_office_hour.save
        format.html { redirect_to @user_office_hour, notice: 'User office hour was successfully created.' }
        format.json { render json: @user_office_hour, status: :created, location: @user_office_hour }
      else
        format.html { render action: "new" }
        format.json { render json: @user_office_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_office_hours/1
  # PUT /user_office_hours/1.json
  def update
    @user_office_hour = UserOfficeHour.find(params[:id])

    respond_to do |format|
      if @user_office_hour.update_attributes(params[:user_office_hour])
        format.html { redirect_to @user_office_hour, notice: 'User office hour was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_office_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_office_hours/1
  # DELETE /user_office_hours/1.json
  def destroy
    @user_office_hour = UserOfficeHour.find(params[:id])
    @user_office_hour.destroy

    respond_to do |format|
      format.html { redirect_to define_profile_path }
      format.json { head :no_content }
    end
  end
end
