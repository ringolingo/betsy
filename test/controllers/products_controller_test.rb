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

  describe "new" do
    it "responds with success" do
      get new_product_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a product with valid data" do
      merchant = merchants(:merchant1)
      perform_login(merchant)
      category = categories(:bedding)
      category_id = [category.id]

      data = {
          product: {
              name: "thing",
              description: "you want one",
              price: 1000,
              stock: 10,
              for_sale: true,
              merchant: merchant,
              category_ids: category_id
          }
      }

      expect {
        post products_path, params: data
      }.must_differ "Product.count", 1

      saved_product = Product.find_by(name: data[:product][:name])
      expect(saved_product.description).must_equal data[:product][:description]
    end

    it "does not create a product with invalid data" do
      merchant = merchants(:merchant1)
      perform_login(merchant)
      category = categories(:bedding)
      category_id = [category.id]

      bad_data = {
          product: {
              name: "thing",
              for_sale: true,
              merchant: merchant,
              category_ids: category_id
          }
      }

      expect {
        post products_path, params: bad_data
      }.wont_differ "Product.count", 1

      failed_product = Product.find_by(name: bad_data[:product][:name])
      expect(failed_product).must_be_nil
    end

    it "does not create a product if  merchant not logged in" do
      category = categories(:bedding)
      category_id = [category.id]

      data = {
          product: {
              name: "thing",
              description: "you want one",
              price: 1000,
              stock: 10,
              for_sale: true,
              category_ids: category_id
          }
      }

      expect {
        post products_path, params: data
      }.wont_differ "Product.count", 1

      failed_product = Product.find_by(name: data[:product][:name])
      expect(failed_product).must_be_nil
    end
  end

  describe "toggle_for_sale" do
    it "retires an active product" do
      merchant = merchants(:merchant1)
      perform_login(merchant)
      current_merchant

      product = products(:product1)
      status = product.for_sale

      patch toggle_for_sale_path(product)

      expect(product.for_sale).must_equal !status
      must_respond_with :redirect
    end

    it "makes a retired product active again" do
      merchant = merchants(:merchant1)
      perform_login(merchant)
      current_merchant

      product = products(:product3)
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
