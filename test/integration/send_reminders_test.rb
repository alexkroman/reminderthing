require 'test_helper'

class SendRemindersTest < ActionController::IntegrationTest
  fixtures :all

  # Replace this with your real tests.
  test "send reminders" do
    visit send_messages_reminders_path
  end
end
