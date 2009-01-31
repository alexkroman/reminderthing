class AddIndexOnSent < ActiveRecord::Migration
  def self.up
    add_index :reminders, :sent
  end

  def self.down
    remove_index :reminders, :sent
  end
end
