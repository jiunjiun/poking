# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new({ email: 'admin@com.tw', password: '12345678', username: 'admin', role: User::Role::ADMIN })
user.skip_confirmation!
user.save

user.observers.create!({
  name: 'test',
  url: 'http://www.google.com',
  interval: 5,
})

user.observers.create!({
  name: 'bearfit',
  url: 'http://localhost:8088',
  interval: 1,
})
