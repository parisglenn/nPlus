class EventMailer < ActionMailer::Base
  default from: "erikosmond@gmail.com"
  def event_reminder(user, ical)
  	@user = user
  	attachments["ical"] = ical
  	mail(to: "#{user.name} <#{user.email}>", subject: "Your Cinder event reminder")
  end
end