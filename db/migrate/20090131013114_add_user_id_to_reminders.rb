class AddUserIdToReminders < ActiveRecord::Migration
  def self.up
    add_column :reminders, :user_id, :integer
    add_index :reminders, :user_id
  end

  def self.down
    remove_column :reminders, :user_id
  end
end
