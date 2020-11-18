require "test_helper"

describe Order do

  before do
    @order = orders(:betty)
  end

  describe 'validations' do

    it 'is valid when all fields are present' do
      expect(@order.valid?).must_equal true
    end

  end

  describe 'relationships' do

    describe 'will be invalid without OrderItem' do

    end

    describe 'can add an OrderItem' do

  end
end
