class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

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
    @event_types = Interest.all
    @event_tags = EventTag.where event_id: @event.id
    @event_tag_ids = @event_tags.map {|et| et.interest_id}
    puts "event tag ids"
    puts @event_tag_ids

  end

  # POST /events
  # POST /events.json
  def create
    @geo = Geo.find params[:event][:geo].to_i
    params[:event][:geo] = @geo
    event_types = params[:event_type]
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        event_types.keys.each do |et|
          puts "event type"
          puts @event.id
          puts et
          interest = Interest.where(name: et).last
          puts interest.inspect
          new_et = EventTag.create!(event_id: @event.id, interest_id: interest.id)
          puts "new et id"
          puts new_et.id
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
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
