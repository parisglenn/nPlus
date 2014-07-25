class ProfilesController < ApplicationController

  #TO DO - add round up times to define, and it's own update method - also edit its view
  def define
    get_user_geos
    get_account_subscriptions
    get_round_up_times
    get_user_office_hours
    @user = User.find current_user.id
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
    get_account_subscriptions
    
    @success_message = "Interests updated successfully"
    render partial: 'subscriptions/account_subscriptions'
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
    get_user_geos

    @success_message = "Geographic settings updated successfully"
    render partial: 'user_geos/account_geos'
  end

  def update_round_up_times
    #keys are the ids of the round up time
    #values are the id of the geo
    @current_user_round_up_times = RoundUpUserAvailability.where(user_id: current_user.id)
    current_user_round_up_time_ids = @current_user_round_up_times.map { |rut| rut.round_up_time_id.to_s }
    current_user_round_up_times_hash = {}
    @current_user_round_up_times.each do |rut|
      current_user_round_up_times_hash[rut.round_up_time_id.to_s] = rut.geo_id.to_s
    end

    new_times_hash = {}
    update_times_hash = {}
    delete_times = []
    params[:round_up_times].each do |rut_id,geo_id|
      if geo_id == "" and current_user_round_up_time_ids.include? rut_id
        delete_times << rut_id
      elsif current_user_round_up_times_hash[rut_id] == nil  
        new_times_hash[rut_id] = geo_id
      elsif current_user_round_up_times_hash[rut_id] != geo_id
        update_times_hash[rut_id] = geo_id
      end
    end
    delete_times.each do |dt|
      rut = RoundUpUserAvailability.where(user_id: current_user.id).where(round_up_time_id: dt.to_i).last
      rut.destroy
    end
    new_times_hash.each do |rut_id,geo_id|
      RoundUpUserAvailability.create!({
        user_id: current_user.id,
        round_up_time_id: rut_id.to_i,
        geo_id: geo_id.to_i
        })
    end
    update_times_hash.each do |rut_id,geo_id|
      rut = RoundUpUserAvailability.
      where(user_id: current_user.id).
      where(round_up_time_id: rut_id.to_i).last
      rut.geo_id = geo_id.to_i 
      rut.save
    end
    get_round_up_times

    @success_message = "Round Up times updated successfully"
    render partial: 'round_up_times/account_round_up_times'
  end

  def update_notification_frequency

  end

  private
    def get_round_up_times
      @geos = Geo.all
      @existing_round_up_times = RoundUpUserAvailability.where user_id: current_user.id
      # delete?   @existing_round_up_time_ids = @existing_round_up_times.map { |r| r.round_up_time_id }
      @existing_round_up_time_geo_hash = {}
      @existing_round_up_times.each do |rut|
        @existing_round_up_time_geo_hash[rut.round_up_time_id] = rut.geo_id
      end
      @round_up_times = RoundUpTime.all
      @office_ids = []
      @city_ids = []
      @geos.each do |g|
        case g.location_type
          when 'office'
            @office_ids << g.id
          when 'city'
            @city_ids << g.id
        end
      end
    end
    
    def get_account_subscriptions
      @subscriptions = Subscription.where user_id: current_user.id
      @existing_subscription_ids = @subscriptions.map { |s| s.interest_id }
      @interests = Interest.all
    end

    def get_user_geos
      @user_geos = UserGeo.where user_id: current_user.id
      @existing_user_geo_ids = []
      @user_geos.each { |s| @existing_user_geo_ids << s.geo_id }
      @geos = Geo.all
    end

    def get_user_office_hours
      @user_office_hour = UserOfficeHour.new
      @users_office_hours = UserOfficeHour.where user_id: current_user.id
    end
end
