module ApplicationHelper
  def display_money(amount)
    return "" unless amount.class == Integer
    return "#{ number_to_currency(amount / 100.0) }"
  end
end
