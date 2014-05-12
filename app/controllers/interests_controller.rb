class InterestsController < ApplicationController
  def index
    @interests = Interest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @interests }
    end
  end

  def show
    @interest = Interest.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @interest }
    end
  end

  def new
    @interest = Interest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @interest }
    end
  end

  def edit
    @interest = Interest.find(params[:id])
  end

  def create
  	@interest = Interest.new(params[:interest])

    respond_to do |format|
      if @interest.save
        format.html { redirect_to @interest, notice: 'Geo was successfully created.' }
        format.json { render json: @interest, status: :created, location: @interest }
      else
        format.html { render action: "new" }
        format.json { render json: @interest.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @interest = Interest.find params[:id]

    respond_to do |format|
      if @interest.update_attributes(params[:interest])
        format.html { redirect_to @interest, notice: 'Interest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @interest.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	###dont destroy if there are events using this add tag - display which events are causing the error
  	###also remove all user_geos with this geo id
    @interest = Interest.find(params[:id])
    @interest.destroy

    respond_to do |format|
      format.html { redirect_to interests_url }
      format.json { head :no_content }
    end
  end
end
