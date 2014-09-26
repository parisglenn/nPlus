require 'mail'

class RoundUpMatchUsersController < ApplicationController

  def update
    @round_up_match_user = RoundUpMatchUser.find(params[:id])
    respond_to do |format|
      if @round_up_match_user.update_attributes(params[:round_up_match_user])
        @round_up_match = RoundUpMatch.find(@round_up_match_user.round_up_match.id)
        # @user1, @user2 = @round_up_match.get_users
        # @comments = @round_up_match.comment_threads.order('created_at desc')
        # @new_comment = Comment.build_from(@round_up_match, current_user.id, "")
        format.html { redirect_to edit_round_up_match_path(@round_up_match.id)
        # format.html { render partial: 'round_up_matches/display_round_up_match'
        #  redirect_to root_url, notice: 'Rsvp was successfully updated.' 
        }
        
        format.json { head :no_content }
      else
        format.html { render root_url }
        format.json { render json: @round_up_match.errors, status: :unprocessable_entity }
      end
    end
  end

  def rsvp
    record = RoundUpRsvpCode.where(code: params[:code]).first
    if record
      @match_user = RoundUpMatchUser.where(user_id: record.user_id, round_up_match_id: record.round_up_match_id).first
      if @match_user.round_up_match.expires_at < Time.now
        records = RoundUpRsvpCode.where(user_id: record.user_id, round_up_match_id: record.round_up_match_id)
        @match_user.rsvp = record.action
        @match_user.save
      else
        @message = "Your Round Up match has expired."
      end
    else
      @message = "Round Up appointment could not be found or you have already RSVP'd to this Round Up match"
    end
  end
  
  def email_match
    @match_user = RoundUpMatchUser.find params[:match_user_id]
    ical = Icalendar::Calendar.new
    e = Icalendar::Event.new
    e.dtstart = DateTime.new(year=@match_user.round_up_match.date.year, 
      month=@match_user.round_up_match.date.month, day=@match_user.round_up_match.date.day,
      hour=@match_user.round_up_match.round_up_time.start_hour.hour)
    e.dtend = (e.dtstart + 1.hour)
    #e.end.icalendar_tzid="UTC"
    e.organizer = 'match_machine@nplus.com'
    e.created = DateTime.now
    e.uid = "#{@match_user.round_up_match_id}_#{@match_user.id}"
    e.summary = "Round Up Match Summary"
    e.description = <<-EOF
    Round Up Match Description
    Your Match: #{(@match_user.round_up_match.get_other_user(@match_user.user_id)).user.name}
    Location: #{@match_user.round_up_match.location}
    Date: #{e.dtstart.strftime('%e %b %Y')}
    Time: #{e.dtstart.strftime('%I:%M %p')}
    EOF
    ical.add_event(e)
    #ical.custom_property({"METHOD" => "REQUEST"})

    RoundUpMailer.round_up_match_appointment(@match_user.user, ical.to_ical).deliver
    #email=mail(to: "erikosmond@gmail.com", subject: "Round Up Match",mime_version: "1.0",body:ical.to_ical,content_disposition: "attachment; filename='calendar.ics'",content_type:"text/calendar")#or content_type:"text/plain"
    #email.header=email.header.to_s+'Content-Class:urn: content-classes:calendarmessage'
    #email.deliver!

    respond_to do |format|
      format.html { redirect_to root_url, notice: "An email invite has been sent to you." }
    end
  end
end