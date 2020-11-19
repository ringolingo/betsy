class AddFieldsToUserForOauth < ActiveRecord::Migration[6.0]
  def change
    add_column :merchants, :uid, :string
    # add_column :merchants, :email, :string
    add_column :merchants, :provider, :string
    add_column :merchants, :avatar, :string
  end
end
