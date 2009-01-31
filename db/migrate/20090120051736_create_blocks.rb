class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.integer :number
      t.string :carrier  
    end

    add_index :blocks, :number
  end

  def self.down
    drop_table :blocks
  end
end
