class UserGeosController < ApplicationController
  # GET /subscriptions
  # GET /subscriptions.json
  @interests = Interest.all
  @geos = Geo.all

  def account_geos
    @user_geos = UserGeo.where user_id: current_user.id
    @existing_user_geo_ids = []
    @user_geos.each { |s| @existing_user_geo_ids << s.geo_id }
    @geos = Geo.all
    render partial: "account_geos"
  end

  def update_account_geos
    @current_user_geos = UserGeo.where(user_id: current_user.id)
    @new_user_geos = params[:geos].keys
    delete_tags = []
    current_tag_names = []
    @current_user_geos.each do |ug|
      geo = Geo.where(id: ug.geo_id).last
      unless @new_user_geos.include? geo.name
        delete_tags << geo.name
      end
      current_tag_names << geo.name
    end
    delete_tags.each do |dt|
      geo = Geo.where(name: dt).last
      old_tag = UserGeo.where(user_id: current_user.id).where(geo_id: geo.id).last
      old_tag.destroy
    end
    # how to destroy multiple records at once?

    add_tags = []
    @new_user_geos.each do |ug|
      unless current_tag_names.include? ug
        add_tags << ug
      end
    end
    add_tags.each do |at|
      geo = Geo.where(name: at).last
      UserGeo.create!({
        user_id: current_user.id,
        geo_id: geo.id
      })
    end

    flash[:notice] = "Geographic settings updated successfully"

    redirect_to root_path
  end
end