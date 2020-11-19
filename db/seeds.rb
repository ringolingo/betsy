# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

MERCHANTS_FILE = Rails.root.join("db", "merchants-seeds.csv")
ORDER_ITEMS_FILE = Rails.root.join("db", "orders-items-seeds.csv")
ORDERS_FILE = Rails.root.join("db", "orders-seeds.csv")
PRODUCTS_FILE = Rails.root.join("db", "products-seeds.csv")

merchant_failures = []
CSV.foreach(MERCHANTS_FILE, headers: true).each do |row|
  merchant = Merchant.new
  merchant.username = row["username"]
  merchant.email = row["email"]

  created = merchant.save
  if !created
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchants to the database"
puts "#{merchant_failures.length} merchants failed to save"



order_failures = []
CSV.foreach(ORDERS_FILE, headers: true).each do |row|
  order = Order.new
  order.status = row["status"]

  created = order.save
  if !created
    order_failures << order
    puts "Failed to save orders: #{order.inspect}"
  else
    puts "Created orders: #{order.inspect}"
  end
end

puts "Added #{Order.count} orders to the database"
puts "#{order_failures.length} orders failed to save"



product_failures = []
CSV.foreach(PRODUCTS_FILE, headers: true).each do |row|
  # name,category,description,price,stock,merchant_id
  product = Product.new
  product.name = row["name"]
  product.category = row["category"]
  product.description = row["description"]
  product.price = row["price"]
  product.stock = row["stock"]
  product.merchant_id = row["merchant_id"]

  created = product.save
  if !created
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} products to the database"
puts "#{product_failures.length} products failed to save"



order_items_failures = []
CSV.foreach(ORDER_ITEMS_FILE, headers: true).each do |row|
  # product_id,order_id,quantity
  order_item = OrderItem.new
  order_item.product_id = row["product_id"]
  order_item.order_id = row["order_id"]
  order_item.quantity = row["quantity"]

  created = order_item.save
  if !created
    order_items_failures << order_item
    puts "Failed to save OrderItem: #{order_item.inspect}"
  else
    puts "Created OrderItem: #{order_item.inspect}"
  end
end
puts "Added #{OrderItem.count} order_items to the database"
puts "#{order_items_failures.length} order_items failed to save"
