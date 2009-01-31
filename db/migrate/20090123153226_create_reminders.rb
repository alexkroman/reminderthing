class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.string :email
      t.string :message
      t.datetime :send_at

      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
