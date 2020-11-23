require "test_helper"
describe Product do
  describe "validations" do

    before do
      @merchant = merchants(:merchant1)
      @new_product = Product.new(
          name: "ultra cozy blanket",
          category: "bedding",
          description: "A nice warm blanket for napping",
          price: 30,
          photo_url: "image.jpeg",
          stock: 8,
          merchant: @merchant
      )
    end

    # it 'must have a merchant' do
    #   # Is this necessary ?
    # end

    it "creates a product" do
      @new_product.save
      expect(@new_product.valid?).must_equal true
    end

    it "does not create a new product without a name" do
      @new_product.name = nil
      expect(@new_product.valid?).must_equal false
    end

    it "does not create a new product without a category" do
      @new_product.category = nil
      expect(@new_product.valid?).must_equal false
    end

    it "does not create a new product without a description" do
      @new_product.description = nil
      expect(@new_product.valid?).must_equal false
    end

    it "does not create a new product without a valid price" do
      @new_product.price = 0
      expect(@new_product.valid?).must_equal false
    end

    # it "does not create a new product without a photo url" do
    #   @new_product.photo_url = nil
    #   expect(@new_product.valid?).must_equal false
    # end

    it "does not create a new product without stock count" do
      @new_product.stock = nil
      expect(@new_product.valid?).must_equal false
    end
  end

  describe "toggle for sale" do
    it "makes an unavailable product available" do
      product = products(:product1)

      product.toggle_for_sale

      expect(product.for_sale).must_equal false
    end

    it "makes an available product unavailable" do
      product = products(:product2)

      product.toggle_for_sale

      expect(product.for_sale).must_equal true
    end
  end
end
