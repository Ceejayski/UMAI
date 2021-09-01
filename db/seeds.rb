# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'ipaddr'

200_000.times do |n|
  User.create(login: Faker::Book.unique.author, password: '123', password_confirmation: '123') if n <= 100
  Post.create(
    title: Faker::Book.title,
    content: Faker::Lorem.paragraphs(number: rand(5..7)),
    user_id: User.limit(1).order('RANDOM()').first.id # sql random
  )
end

10_000.times do |n|
  if n <= 50
    Ip.create(
      ip_address: IPAddr.new(rand(2**32), Socket::AF_INET),
      login: User.limit(1).order('RANDOM()').first.login, # sql random
      post_id: Post.limit(1).order('RANDOM()').first.id
    )
    user = User.limit(1).order('RANDOM()').first
    Feedback.create(
      comment: nil,
      owner_id: user.id,
      owner_type: 'User'
    )
  elsif n <= 100
    post = Post.limit(1).order('RANDOM()').first
    post.ratings.create(
      value: Faker::Number.between(from: 1, to: 5),
      user_id: User.limit(1).order('RANDOM()').first.id, # sql random
      post_id: Post.limit(1).order('RANDOM()').first.id
    )
  end
  post = Post.limit(1).order('RANDOM()').first
  Feedback.create(
    comment: post.avg_ratings,
    owner_id: post.id,
    owner_type: 'Post'
  )
end
