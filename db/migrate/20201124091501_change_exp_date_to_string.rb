class ChangeExpDateToString < ActiveRecord::Migration[6.0]
  def change
    remove_column(:orders, :expiration_date)
    add_column(:orders, :expiration_date, :string)
  end
end
