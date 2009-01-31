class AddSessionToReminders < ActiveRecord::Migration
  def self.up
    add_column :reminders, :session_id, :string
  end

  def self.down
    remove_column :reminders, :session_id
  end
end
