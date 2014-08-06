class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.where("event_date >= ?",Date.today)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @event_tags = EventTag.where event_id: @event.id
    @attending_users = @event.attending_users
    #move the host logic to the event model
    hosts = Rsvp.where(event_id: @event.id).where(host: true)
    @host_ids = hosts.map(&:user_id)
    @comments = @event.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@event, current_user.id, "")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @event_types = Interest.all
    @event_tag_ids = []

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @rsvp = Rsvp.where(event_id: @event.id).where(user_id: current_user.id).last
    if !@rsvp.nil? && @rsvp.host == true
      @event_types = Interest.all
      @event_tags = EventTag.where event_id: @event.id
      @event_tag_ids = @event_tags.map {|et| et.interest_id}
    else
      redirect_to @event
    end
  end

  # POST /events
  # POST /events.json
  def create
    @geo = Geo.find params[:event][:geo].to_i
    params[:event][:geo] = @geo
    event_types = params[:event_type]
    @event = Event.new(params[:event])
    date = format_date
    @event.event_date = date

    respond_to do |format|
      if @event.save && Rsvp.create!({
          user_id: current_user.id,
          event_id: @event.id,
          host: true,
          status: 'attending'
        })  
        event_types.keys.each do |et|
          interest = Interest.where(name: et).last
          new_et = EventTag.create!(event_id: @event.id, interest_id: interest.id)
        end
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @geo = Geo.find params[:event][:geo].to_i
    params[:event][:geo] = @geo
    @event = Event.find(params[:id])
    @event_tags = EventTag.where(event_id: @event.id)
    delete_tags = []
    param_events = params[:event_type].keys
    current_tag_names = []
    @event_tags.each do |et|
      interest = Interest.where(id: et.interest_id).last
      unless param_events.include? interest.name
        delete_tags << interest.name
      end
      current_tag_names << interest.name
    end
    delete_tags.each do |dt|
      interest = Interest.where(name: dt).last
      old_tag = EventTag.where(event_id: @event.id).where(interest_id: interest.id).last
      old_tag.destroy
    end
    # how to destroy multiple records at once?

    add_tags = []
    param_events.each do |pe|
      unless current_tag_names.include? pe
        add_tags << pe
      end
    end
    add_tags.each do |at|
      interest = Interest.where(name: at).last
      EventTag.create!({
        event_id: @event.id,
        interest_id: interest.id
      })
    end

    #look at current tags
    #look at tags in the params
    #if a tag is in the current, but not in the params, it should get deleted
    #if a tag is in the params but not in current, it should get added
    @event.event_date = format_date
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @rsvp = Rsvp.where(user_id: current_user.id).where(event_id: @event.id).last

    respond_to do |format|
      if !@rsvp.nil? && @rsvp.host == true
        @event.destroy
        format.html { redirect_to events_url }
        format.json { head :no_content }
      else
        flash[:error] = "To delete an event you must be a host"
        @event_tags = EventTag.where event_id: @event.id
        @attending_users = @event.attending_users        
        format.html { render action: "show" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def format_date
      date_array = params[:event][:event_date].split("/")
      month = date_array[0]
      day   = date_array[1] 
      year  = date_array[2]
      #{}"#{year}-#{month}-#{day}"
      Date.new(year.to_i, month.to_i, day.to_i)
    end
end
