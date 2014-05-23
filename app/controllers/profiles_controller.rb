class ProfilesController < ApplicationController

  #TO DO - add round up times to define, and it's own update method - also edit its view
  def define
    #get user geos
    @user_geos = UserGeo.where user_id: current_user.id
    @existing_user_geo_ids = []
    @user_geos.each { |s| @existing_user_geo_ids << s.geo_id }
    @geos = Geo.all
    #render partial: "account_geos"
    
    #get account subscriptions
    @subscriptions = Subscription.where user_id: current_user.id
    @existing_subscription_ids = @subscriptions.map { |s| s.interest_id }
    @interests = Interest.all
    #render partial: "account_subscriptions"
  end

  def update_subscriptions
    @current_subscriptions = Subscription.where(user_id: current_user.id)
    if params[:interests].nil?
      @current_subscriptions.each { |s| s.destroy }
    else  
      @new_subscriptions = params[:interests].keys
      delete_tags = []
      current_tag_names = []
      @current_subscriptions.each do |cs|
        interest = Interest.where(id: cs.interest_id).last
        unless @new_subscriptions.include? interest.name
          delete_tags << interest.name
        end
        current_tag_names << interest.name
      end
      delete_tags.each do |dt|
        interest = Interest.where(name: dt).last
        old_tag = Subscription.where(user_id: current_user.id).where(interest_id: interest.id).last
        old_tag.destroy
      end
      # how to destroy multiple records at once?

      add_tags = []
      @new_subscriptions.each do |ns|
        unless current_tag_names.include? ns
          add_tags << ns
        end
      end
      add_tags.each do |at|
        interest = Interest.where(name: at).last
        Subscription.create!({
          user_id: current_user.id,
          interest_id: interest.id
        })
      end
    end
    flash[:notice] = "Subscriptions updated successfully"

    redirect_to define_profile_path #root_path
  end

  def update_account_geos
    @current_user_geos = UserGeo.where(user_id: current_user.id)
    if params[:geos].nil?
      @current_user_geos.each { |g| g.destroy }
    else  
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
    end

    flash[:notice] = "Geographic settings updated successfully"

    redirect_to define_profile_path #root_path
  end
end
