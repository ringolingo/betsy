require "test_helper"

describe Order do

  before do
    @order = orders(:betty)
  end

  describe 'validations' do

    it 'is valid when all fields are present' do
      #order_item = OrderItem.create(product_id: 1, order_id: @orders.id)
      expect(@order.valid?).must_equal true
    end

    it 'will be invalid without status' do

      @order.status = nil

      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :status
      expect(@order.errors.messages[:status][0]).must_equal "can't be blank"

    end

    it 'will be invalid with status other than paid or processing' do
      @order.status = 'nope'

      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :status
      expect(@order.errors.messages[:status][0]).must_equal "nope is not a valid status"
    end

    it 'will be invalid if status is paid and name is blank' do
      @order.status = 'paid'
      @order.name = nil


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :name
      expect(@order.errors.messages[:name][0]).must_equal "can't be blank"

    end

    it 'will be valid if status is pending and name is blank' do
      @order.status = 'pending'
      @order.name = nil

      expect(@order.valid?).must_equal true
    end

    it 'will be invalid if status is paid and address is blank' do
      @order.status = 'paid'
      @order.address = nil


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :address
      expect(@order.errors.messages[:address][0]).must_equal "can't be blank"

    end

    it 'will be valid if status is pending and address is blank' do
      @order.status = 'pending'
      @order.address = nil

      expect(@order.valid?).must_equal true
    end

    it 'will be invalid if status is paid and email is blank' do
      @order.status = 'paid'
      @order.email = nil


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :email
      expect(@order.errors.messages[:email][0]).must_equal "can't be blank"

    end

    it 'will be valid if status is pending and email is blank' do
      @order.status = 'pending'
      @order.email = nil

      expect(@order.valid?).must_equal true
    end

    it 'will be invalid if status is paid and expiration_date is blank' do
      @order.status = 'paid'
      @order.expiration_date = nil


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :expiration_date
      expect(@order.errors.messages[:expiration_date][0]).must_equal "can't be blank"

    end

    it 'will be valid if status is pending and expiration_date is blank' do
      @order.status = 'pending'
      @order.expiration_date = nil

      expect(@order.valid?).must_equal true
    end

    it 'will be invalid if status is paid and cvv is blank' do
      @order.status = 'paid'
      @order.cvv = nil


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cvv
      expect(@order.errors.messages[:cvv][0]).must_equal "can't be blank"

    end

    it 'will be valid if status is pending and cvv is blank' do
      @order.status = 'pending'
      @order.cvv = nil

      expect(@order.valid?).must_equal true
    end

    it 'will be invalid if status is paid and cvv has < 3 digits' do
      @order.status = 'paid'
      @order.cvv = 10


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cvv
      expect(@order.errors.messages[:cvv][0]).must_equal "CVV is incorrectly formatted"

    end

    it 'will be invalid if status is paid and cvv has > 4 digits' do
      @order.status = 'paid'
      @order.cvv = 10000


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cvv
      expect(@order.errors.messages[:cvv][0]).must_equal "CVV is incorrectly formatted"
    end

    it 'will be invalid if status is paid and cvv is non-integer' do
      @order.status = 'paid'
      @order.cvv = 109.6565


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cvv
      expect(@order.errors.messages[:cvv][0]).must_equal "CVV is incorrectly formatted"
    end

    it 'will be invalid if status is paid and zip code is blank' do
      @order.status = 'paid'
      @order.zip_code = nil


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :zip_code
      expect(@order.errors.messages[:zip_code][0]).must_equal "can't be blank"

    end

    it 'will be invalid if status is paid and zip code is non-integer' do
      @order.status = 'paid'
      @order.zip_code = 22026.6565

      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :zip_code
      expect(@order.errors.messages[:zip_code][0]).must_equal "Zip Code is incorrectly formatted"

    end

    it 'will be invalid if status is paid and zip code is higher than highest-number zip' do
      @order.status = 'paid'
      @order.zip_code = 999999

      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :zip_code
      expect(@order.errors.messages[:zip_code][0]).must_equal "Zip Code is incorrectly formatted"

    end
    it 'will be valid if status is pending and zip_code is blank' do
      @order.status = 'pending'
      @order.zip_code = nil

      expect(@order.valid?).must_equal true
    end

    it 'will be invalid if status is paid and cc number is blank' do
      @order.status = 'paid'
      @order.credit_card_number = nil


      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :credit_card_number
      expect(@order.errors.messages[:credit_card_number][0]).must_equal "can't be blank"
    end

  end

  describe 'relationships' do

    it "has many order items" do
      expect(@order).must_respond_to :order_items
    end

    it 'OrderItem can add an Order' do
      order_item = OrderItem.create(product: products(:blanket), order: @order)
      expect(order_item.order.name).must_equal "Betty Elms"
    end

    it 'Can access Product through OrderItem' do
      order_item = OrderItem.create(product: products(:blanket), order: @order)
      expect(order_item.order.name).must_equal "Betty Elms"
    end

  end

  describe 'custom methods' do

    describe 'total' do
      it 'will return the total' do
        expect(@order.sub_total).must_equal 19000
      end


      it 'will return 0 if nothing is in order' do
        @order.order_items.delete_all
        expect(@order.sub_total).must_equal 0
      end

    end

    describe 'total' do

      it 'will return the total plus taxes and shipping' do
        expect(@order.total(tax: 0.065, shipping: 500)).must_equal 20735
      end

      it 'will return 0 if nothing is in the order' do
        @order.order_items.delete_all
        expect(@order.sub_total).must_equal 0
      end
    end
  end
end
