class EventMailer < ActionMailer::Base
  default from: "erikosmond@gmail.com"
  def event_reminder(user, ical)
  	@user = user
  	attachments["ical"] = ical
  	mail(to: "#{user.name} <#{user.email}>", subject: "Your Cinder event reminder")
  end
end

#email=mail(to: "erikosmond@gmail.com", subject: "Round Up Match",mime_version: "1.0",body:ical.to_ical,content_disposition: "attachment; filename='calendar.ics'",content_type:"text/calendar")#or content_type:"text/plain"
    #email.header=email.header.to_s+'Content-Class:urn: content-classes:calendarmessage'