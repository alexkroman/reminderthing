class AddSentToReminders < ActiveRecord::Migration
  def self.up
    add_column 'reminders', 'sent', :boolean, :default => false
  end

  def self.down
    remove_column 'reminders', 'sent'
  end
end
