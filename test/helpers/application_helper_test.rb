require "test_helper"

describe ApplicationHelper, :helper do
  describe "display_money" do
    it "returns stored integer converted into dollars" do
      price = 1165

      result = display_money(price)

      expect(result).must_equal "$11.65"
    end

    it "returns an empty string if called on a non-integer" do
      price = "five"

      result = display_money(price)

      expect(result).must_equal ""
    end

    it "returns an empty string if passed noting" do
      price = nil

      result = display_money(price)

      expect(result).must_equal ""
    end
  end
end