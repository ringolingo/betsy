module ApplicationHelper

  def display_currency(amount)
    number_to_currency(amount/100)
  end
end
