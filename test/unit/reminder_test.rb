require 'test_helper'

class ReminderTest < ActiveSupport::TestCase
  context "A reminder" do

    setup do
      @reminder = Factory.new_reminder(:carrier => 'verizon')
    end

  end
end
