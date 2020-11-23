require "test_helper"

describe ProductsController do
  describe "index" do
    it "responds with success when there are many products" do
      get products_path

      must_respond_with :success
    end

    it "responds with success when there are no products" do
      Product.destroy_all

      get products_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success for a valid product" do
      product = products(:product1)

      get product_path(product.id)

      must_respond_with :success
    end

    it "redirects for an invalid product" do
      product_id = 800

      get product_path(product_id)

      must_respond_with :redirect
    end
  end

  describe "toggle_for_sale" do
    it "retires an active product" do
      merchant = merchants(:merchant1)
      product = products(:product1)
      perform_login(merchant)
      status = product.for_sale

      patch toggle_for_sale_path(product)

      expect(product.for_sale).must_equal !status
      must_respond_with :redirect
    end

    it "makes a retired product active again" do
      merchant = merchants(:merchant1)
      product = products(:product3)
      perform_login(merchant)
      status = product.for_sale

      patch toggle_for_sale_path(product)

      expect(product.for_sale).must_equal !status
      must_respond_with :redirect
    end

    it "makes no change if user is not the product's seller" do
      merchant = merchants(:merchant3)
      product = products(:product1)
      perform_login(merchant)
      status = product.for_sale

      patch toggle_for_sale_path(product)

      must_respond_with :redirect
      expect(product.for_sale).must_equal status
    end
  end
end
