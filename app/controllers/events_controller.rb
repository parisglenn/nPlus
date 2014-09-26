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

  def past_events
    @events = Event.where("event_date < ?",Date.today).where("event_date >= ?", 60.days.ago)

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
    @actions = []
    @new_rsvp = Rsvp.where(user_id: current_user.id, event_id: @event.id).first
    @new_rsvp = Rsvp.new(user_id: current_user.id, event_id: @event.id) unless @new_rsvp 
    @actions << :attending unless @new_rsvp.status == 'attending' or @event.hosts_include? current_user
    @actions << :declined unless @new_rsvp.status == 'declined' or @event.hosts_include? current_user
    @actions << :maybe unless @new_rsvp.status == 'maybe' or @event.hosts_include? current_user
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
    format_date_display
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
    date = format_date_save params[:event][:event_date]
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
    params[:event][:event_date]= format_date_save params[:event][:event_date]
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

  def email_event
    @event = Event.find params[:event_id]
    ical = Icalendar::Calendar.new
    e = Icalendar::Event.new
    e.dtstart = DateTime.new(year=@event.event_date.year, 
      month=@event.event_date.month, day=@event.event_date.day,
      hour=@event.starts_at.hour, minute=@event.starts_at.min)
    e.dtend = DateTime.new(year=@event.event_date.year, 
      month=@event.event_date.month, day=@event.event_date.day,
      hour=@event.ends_at.hour, minute=@event.ends_at.min)
    #e.end.icalendar_tzid="UTC"
    e.organizer = 'event_machine@nplus.com'
    e.created = DateTime.now
    e.uid = "#{@event.id}_#{@current_user.id}"
    e.summary = "Cinder event reminder"
    e.description = <<-EOF
    Event summary
    Event: #{@event.name}
    Location: #{@event.location}
    Date: #{e.dtstart.strftime('%e %b %Y')}
    Time: #{e.dtstart.strftime('%I:%M %p')}
    EOF
    ical.add_event(e)
    #ical.custom_property({"METHOD" => "REQUEST"})

    EventMailer.event_reminder(current_user, ical.to_ical).deliver
    #email=mail(to: "erikosmond@gmail.com", subject: "Round Up Match",mime_version: "1.0",body:ical.to_ical,content_disposition: "attachment; filename='calendar.ics'",content_type:"text/calendar")#or content_type:"text/plain"
    #email.header=email.header.to_s+'Content-Class:urn: content-classes:calendarmessage'
    #email.deliver!

    respond_to do |format|
      format.html { redirect_to root_url, notice: "An email invite has been sent to you." }
    end
  end

end
