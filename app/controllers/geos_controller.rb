class GeosController < ApplicationController
  before_filter :authorize_admin
  def index
    @geos = Geo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @geos }
    end
  end

  def show
    @geo = Geo.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @geo }
    end
  end

  def new
    @geo = Geo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @geo }
    end
  end

  def edit
    @geo = Geo.find(params[:id])
  end

  def create
  	@geo = Geo.new(params[:geo])

    respond_to do |format|
      if @geo.save
        format.html { redirect_to @geo, notice: 'Geo was successfully created.' }
        format.json { render json: @geo, status: :created, location: @geo }
      else
        format.html { render action: "new" }
        format.json { render json: @geo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @geo = Geo.find params[:id]

    respond_to do |format|
      if @geo.update_attributes(params[:geo])
        format.html { redirect_to @geo, notice: 'Geo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @geo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	###dont destroy if there are events using this geo tag - display which events are causing the error
  	###also remove all user_geos with this geo id
    @geo = Geo.find(params[:id])
    user_geos = UserGeo.where geo_id: @geo.id
    user_geos.each do |ug|
      ug.destroy
    end
    @geo.destroy


    respond_to do |format|
      format.html { redirect_to geos_url }
      format.json { head :no_content }
    end
  end
end
