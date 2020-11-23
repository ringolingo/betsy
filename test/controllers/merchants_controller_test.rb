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
end
