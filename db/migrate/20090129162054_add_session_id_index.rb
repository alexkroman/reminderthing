class AddSessionIdIndex < ActiveRecord::Migration
  def self.up
    add_index :reminders, :session_id
  end

  def self.down
    remove_index :reminders, :session_id
  end
end
