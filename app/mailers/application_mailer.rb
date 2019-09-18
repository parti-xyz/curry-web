class ApplicationMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  default from: "contact@campaigns.kr"
  layout 'mailer'
end
