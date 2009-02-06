class AddTypeToReminder < ActiveRecord::Migration
  def self.up
    add_column :reminders, :type, :string
  end

  def self.down
    remove_column :reminders, :type
  end
end
