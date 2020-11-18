class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.string :username
      t.string :email
      t.string :description

      t.timestamps
    end
  end
end
