User.create!(name: 'TuanAnh',
  email: 'phantuananhltt@gmail.com',
  address: '58 Dung Si Thanh Khe',
  password: 'Test123@',
  phone_number: '0987654321',
  role: 0
)

#User
30.times do |n|
  User.create!(
    name: Faker::Name.name,
    email: "user#{ n + 1 }@gmail.com",
    address: Faker::Address.full_address,
    password: 'Test123@',
    phone_number: Faker::Number.leading_zero_number(digits: 10)
  )
end

# Categories
Category.create!(name: 'Laptop')
Category.create!(name: 'Phone')
categories = ['Macbook', 'Iphone', 'Asus', 'Xiaomi', 'MSI',
              'SamSung', 'Dell', 'Nokia']
categories.each do |category|
  Category.create!(
    name: category,
    parent_id: Category.limit(2).pluck(:id).sample
  )
end

# Brands
brands = ['Apple', 'Xiaomi', 'Dell', 'Asus', 'SamSung']
brands.each do |brand|
  Brand.create!(
    name: brand,
    origin: Faker::Address.country_code
  )
end

# Stores
5.times do
  Store.create!(
    name: Faker::Commerce.department(max: 2, fixed_amount: true),
    address: Faker::Address.full_address,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude
  )
end

# Products
categories = Category.where(parent_id: nil)
subCategories = Category.all - categories
20.times do |n|
  Product.create!(
    category_id: subCategories.pluck(:id).sample,
    brand_id: Brand.pluck(:id).sample,
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Number.decimal(l_digits: 2),
    quantity: Faker::Number.non_zero_digit,
  )
end

# Vouchers
4.times do |n|
  Voucher.create!(
    code: "Voucher#{ n + 1 }",
    discount: Faker::Number.decimal(l_digits: 1, r_digits: 2),
    condition: Faker::Number.decimal(l_digits: 2),
    expiry_date: Faker::Date.forward(days: 3),
    usage_limit: Faker::Number.non_zero_digit
  )
end

# Orders
12.times do |n|
  Order.create!(
    user_id: User.pluck(:id).sample,
    name: Faker::Name.name,
    phone_number: Faker::Number.leading_zero_number(digits: 10),
    address: Faker::Address.full_address,
    total: Faker::Number.decimal(l_digits: 3),
    status: Order.statuses.values.sample,
    delivery_time: Faker::Time.backward(days: 10),
  )
end

# Orders Details
orders = Order.all
orders.each do |order|
  20.times do |n|
    OrderDetail.create!(
      order_id: order.id,
      product_id: Product.pluck(:id).sample,
      price: Faker::Number.decimal(l_digits: 2),
      quantity: rand(1..10)
    )
  end
end

# Ratings
10.times do |n|
  Rating.create!(
    user_id: User.pluck(:id).sample,
    product_id: Product.pluck(:id).sample,
    point: rand(1..5),
    content: Faker::Lorem.sentences
  )
end
