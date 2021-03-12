class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer.email
  layout 'mailer'
end
