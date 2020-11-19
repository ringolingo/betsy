class CreateMerchantsOrdersJoin < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants_orders do |t|
      t.belongs_to :merchant, index: true
      t.belongs_to :order, index: true
    end
  end
end
