require "test_helper"

describe MerchantsController do
  describe "index" do
    it "responds with success when there are multiple merchants" do
      get merchants_path

      must_respond_with :success
    end

    it "responds with success when there are no merchants" do
      Merchant.destroy_all

      get merchants_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing merchant" do
      merchant = merchants(:merchant1)

      get merchant_path(merchant.id)

      must_respond_with :success
    end

    it "redirects for an invalid merchant id" do
      merchant_id = 1000

      get merchant_path(merchant_id)

      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "responds with success getting the edit page for a real merchant" do
      merchant = merchants(:merchant1)
      perform_login(merchant)

      get edit_merchant_path(merchant.id)

      must_respond_with :success
    end

    it "redirects when asked to edit a non-real merchant" do
      merchant_id = -1

      get edit_merchant_path(merchant_id)

      must_respond_with :redirect
    end

    it "redirects if the merchant is not logged in" do
      merchant = merchants(:merchant2)
      get edit_merchant_path(merchant.id)

      must_respond_with :redirect
    end
  end

  describe "update" do
    before do
      @merchant = merchants(:merchant3)
    end

    it "can update the logged in user with valid info" do
      perform_login(@merchant)
      new_info = {
          merchant: {
            username: "The Best Merchant",
            email: "winner@crushingit.com",
            description: "stuff so good you can't help but buy it"
          }
      }

      expect {
        patch merchant_path(@merchant), params: new_info
      }.wont_change Merchant.count

      updated_merchant = Merchant.find_by(id: @merchant.id)

      expect(updated_merchant.username).must_equal new_info[:merchant][:username]
      expect(updated_merchant.email).must_equal new_info[:merchant][:email]
      expect(updated_merchant.description).must_equal new_info[:merchant][:description]

      must_respond_with :redirect
    end

    it "does not update the user if not logged in" do
      new_info = {
          merchant: {
              username: "The Best Merchant",
              email: "winner@crushingit.com",
              description: "stuff so good you can't help but buy it"
          }
      }

      expect {
        patch merchant_path(@merchant), params: new_info
      }.wont_change Merchant.count

      updated_merchant = Merchant.find_by(id: @merchant.id)

      expect(updated_merchant.username).must_equal @merchant.username
      expect(updated_merchant.email).must_equal @merchant.email
      expect(updated_merchant.description).must_equal @merchant.description

      must_respond_with :redirect
    end

    it "redirects if asked to update non-existent merchant" do
      perform_login(@merchant)
      fake_merchant_id = -1
      new_info = {
          merchant: {
              username: "The Best Merchant",
              email: "winner@crushingit.com",
              description: "stuff so good you can't help but buy it"
          }
      }

      expect {
        patch merchant_path(fake_merchant_id), params: new_info
      }.wont_change Merchant.count

      updated_merchant = Merchant.find_by(id: @merchant.id)

      expect(updated_merchant.username).must_equal @merchant.username
      expect(updated_merchant.email).must_equal @merchant.email
      expect(updated_merchant.description).must_equal @merchant.description

      must_respond_with :redirect
    end

    it "does not update user if info is invalid" do
      perform_login(@merchant)
      new_info = {
          merchant: {
              username: "",
              email: "",
              description: "whoops"
          }
      }

      expect {
        patch merchant_path(@merchant), params: new_info
      }.wont_change Merchant.count

      updated_merchant = Merchant.find_by(id: @merchant.id)

      expect(updated_merchant.username).must_equal @merchant.username
      expect(updated_merchant.email).must_equal @merchant.email
      expect(updated_merchant.description).must_equal @merchant.description
    end
  end


end
