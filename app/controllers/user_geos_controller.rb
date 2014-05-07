class UserGeosController < ApplicationController
  # GET /subscriptions
  # GET /subscriptions.json
  @interests = Interest.all
  @geos = Geo.all

  def account_geos
    @subscriptions = Subscription.where user_id: current_user.id
    @existing_subscription_ids = []
    @subscriptions.each { |s| @existing_subscription_ids << s.interest_id }
    @interests = Interest.all
    render partial: "account_subscriptions"
  end

  def update_account_geos
    @current_subscriptions = Subscription.where(user_id: current_user.id)
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

    flash[:notice] = "Subscriptions updated successfully"

    redirect_to root_path
  end
end