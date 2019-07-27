require 'test_helper'

class VoteawardMailerTest < ActionMailer::TestCase
  test "email_confirmation" do
    mail = VoteawardMailer.email_confirmation
    assert_equal "Email confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
