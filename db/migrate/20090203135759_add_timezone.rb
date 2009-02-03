class AddTimezone < ActiveRecord::Migration
  def self.up
    add_column :users, :time_zone, :integer
  end

  def self.down
    remove_column :users, :time_zone
  end
end
