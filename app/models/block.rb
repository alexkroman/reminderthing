class Block < ActiveRecord::Base

  def self.find_carrier(number)
    find_by_number(number[0..6]).carrier
  rescue
    nil
  end
    
end
