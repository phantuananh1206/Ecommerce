class ApplicationMailer < ActionMailer::Base
  default from: Settings.Mailer.email
  layout 'mailer'
end
