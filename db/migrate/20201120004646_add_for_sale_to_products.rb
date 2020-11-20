class AddForSaleToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :for_sale, :boolean
  end
end
