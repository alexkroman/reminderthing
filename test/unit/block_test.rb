require 'test_helper'

class BlockTest < ActiveSupport::TestCase

  context "A block" do

    setup do
      @block = Factory.new_block(:carrier => 'verizon')
    end

    should "find a carrier" do
      Block.expects(:find_by_number).returns(@block)
      assert_equal @block.carrier, Block.find_carrier('9712357291')
    end

    should "not find a carrier" do
      Block.expects(:find_by_number).returns{ raise ActiveRecord::RecordNotFound }
      assert_equal nil, Block.find_carrier('9712357291')
    end

  end

end
