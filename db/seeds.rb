# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'ipaddr'

100.times do
  User.create(login: Faker::Book.unique.author, password: '123', password_confirmation: '123')
end

200_000.times do
  Post.create(
    title: Faker::Book.title,
    content: Faker::Lorem.paragraphs(number: rand(5..7)),
    user_id: User.limit(1).order('RANDOM()').first.id # sql random
  )
end

50.times do
  Ip.create(
    ip_address: IPAddr.new(rand(2**32), Socket::AF_INET),
    login: User.limit(1).order('RANDOM()').first.login, # sql random
    post_id: Post.limit(1).order('RANDOM()').first.id
  )
end

100.times do
  Rating.create(
    value: Faker::Number.between(from: 1, to: 5),
    user_id: User.limit(1).order('RANDOM()').first.id, # sql random
    post_id: Post.limit(1).order('RANDOM()').first.id
  )
end

10_000.times do
  post = Post.limit(1).order('RANDOM()').first
  Feedback.create(
    comment: post.average_rating,
    owner_id: post.id,
    owner_type: 'Post',
    other_feedbacks: Feedback.where(owner_id: post.id, owner_type: 'Post').map(&:id)
  )
end

50.times do
  post = User.limit(1).order('RANDOM()').first
  Feedback.create(
    comment: nil,
    owner_id: post.id,
    owner_type: 'User',
    other_feedbacks: Feedback.where(owner_id: post.id, owner_type: 'user').map(&:id)
  )
end
