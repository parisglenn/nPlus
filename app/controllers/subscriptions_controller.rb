class SubscriptionsController < ApplicationController
  # GET /subscriptions
  # GET /subscriptions.json
  @interests = Interest.all
  @geos = Geo.all
  def index
    #require admin access to edit site wide interests
    @subscriptions = Subscription.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    #require admin access to edit site wide interests
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
    #require admin access to edit site wide interests
    @subscription = Subscription.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/1/edit
  def edit
    #require admin access to edit site wide interests
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    #require admin access to edit site wide interests
    @subscription = Subscription.new(params[:subscription])

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to @subscription, notice: 'Subscription was successfully created.' }
        format.json { render json: @subscription, status: :created, location: @subscription }
      else
        format.html { render action: "new" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    #require admin access to edit site wide interests
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    #require admin access to edit site wide interests
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to subscriptions_url }
      format.json { head :no_content }
    end
  end

  def account_subscriptions
    @subscriptions = Subscription.where user_id: current_user.id
    @existing_subscription_ids = []
    @subscriptions.each { |s| @existing_subscription_ids << s.interest_id }
    @interests = Interest.all
    render partial: "account_subscriptions"
  end

  def update_subscriptions
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
