class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.integer :sub_total
      t.integer :order_total
      t.string :name
      t.string :address
      t.string :email
      t.integer :credit_card_number
      t.datetime :expiration_date
      t.integer :cvv
      t.integer :zip_code

      t.timestamps
    end
  end
end
