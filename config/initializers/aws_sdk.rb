require 'json'

creds = Aws::Credentials.new(ENV['AWS_SES_ACCESS_KEY'], ENV['AWS_SES_SECRET_KEY'])
Aws::Rails.add_action_mailer_delivery_method(:aws_sdk, credentials: creds, region: 'us-west-2')
