require "test_helper"

describe OrderItemsController do

  describe 'destroy' do

  end

  describe 'update' do

    let(:order_item_params){
      {
          order_item: {
              quantity: 10
          }
      }
    }

    it "can update an existing OrderItem" do


      id = OrderItem.first.id
      expect{
        patch order_item_path(id), params: order_item_hash
      }.wont_change "Work.count"

      must_respond_with :redirect

      test_order_item = OrderItem.find_by(id: id)
      expect(test_order_item.quantity).must_equal order_item_hash[:order_item][:quantity]

      expect(flash[:success]).must_equal "Successfully updated movie #{id}"
    end
  end


end
