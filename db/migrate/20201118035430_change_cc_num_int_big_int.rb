class ChangeCcNumIntBigInt < ActiveRecord::Migration[6.0]
  def change
    remove_column(:orders, :credit_card_number)
    add_column(:orders, :credit_card_number, :bigint)
  end
end
