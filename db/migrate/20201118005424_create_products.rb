class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.string :photo_url
      t.integer :stock

      t.timestamps
    end
  end
end