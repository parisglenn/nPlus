class RoundUpMailer < ActionMailer::Base
  default from: "erikosmond@gmail.com"
  def round_up_match_appointment(user, ical)
  	@user = user
  	attachments["ical"] = ical
  	mail(to: "#{user.db_user.name} <#{user.db_user.email}>", subject: "Your Round Up match calendar appointment")
  end

  def round_up_match_rsvp(user, match_user, match, attending, decline)
  	@user = user
  	@match_user = match_user
  	@accept_code = attending
  	@decline_code = decline
  	@match = match
  	mail(to: "#{user.db_user.name} <#{user.db_user.email}>", subject: "Your Round Up match")
  end
end

#email=mail(to: "erikosmond@gmail.com", subject: "Round Up Match",mime_version: "1.0",body:ical.to_ical,content_disposition: "attachment; filename='calendar.ics'",content_type:"text/calendar")#or content_type:"text/plain"
    #email.header=email.header.to_s+'Content-Class:urn: content-classes:calendarmessage'