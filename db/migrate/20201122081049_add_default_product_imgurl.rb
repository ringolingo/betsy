class AddDefaultProductImgurl < ActiveRecord::Migration[6.0]
  def change
    remove_column(:products, :photo_url)
    add_column(:products, :photo_url,  :string, default: "https://i.ibb.co/sHTKJ62/moon.jpg")
  end
end
