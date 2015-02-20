class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    if current_user.admin
      @users = User.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    else
      flash[:notice] = "You have been redirected as you do not have permission to access the requested page"
      redirect_to root_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @users_office_hours = UserOfficeHour.where user_id: @user.id
    @user_office_hour = UserOfficeHour.new if @users_office_hours.empty?

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    if current_user.admin || current_user.id.to_s == params[:id]
      @user = User.find(params[:id])
    else
      flash[:notice] = "You have been redirected as you do not have permission to access the requested page"
      redirect_to root_path
    end
  end

  # POST /users
  # POST /users.json
  def create
    @office = Office.find(params[:user][:office])
    @team = Team.find(params[:user][:team])
    num_users = User.count
    @user = User.new

    @user.assign_attributes(:full_name => params[:user][:full_name], 
                              :email => params[:user][:email],
                              :password => params[:user][:password],
                              :office => @office,
                              :team => @team,
                              admin: ((num_users==1) ? true : false)
                              )

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'User was successfully created.' }
        format.json 
      else
        format.html { redirect_to '/sessions/user', flash: 'Account creation unsuccessful.  Please check your invite code.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if current_user.admin || current_user.id.to_s == params[:id]
      @user = User.find(params[:id])

      respond_to do |format|
        if @user.update_attributes(params[:user])
          if params[:redirect] == "profile"
            @success_message = "Email preferences successfully updated"
            render partial: 'users/email_frequencies' and return
          end
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:notice] = "You have been redirected as you do not have permission to access the requested page"
      redirect_to root_path
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user.admin
      @user = User.find(params[:id])
      @user.destroy

      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    else
      flash[:notice] = "You have been redirected as you do not have permission to access the requested page"
      redirect_to root_path
    end
  end
end
