class AddPhoneNumberToReminder < ActiveRecord::Migration
  def self.up
    add_column :reminders, :phone_number, :string
  end

  def self.down
    remove_column :reminders, :phone_number
  end
end
