require 'faker'

puts "🌱 Seeding spices..."



10.times do
  User.create(
    full_name: Faker::Name.name,
    email: Faker::Internet.email,
    password_hash: Faker::Internet.password(min_length: 8)
  )
end


20.times do
  Task.create(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    due: Faker::Time.forward(days: 7),
    created_at: Faker::Time.backward(days: 14),
    user: User.order("RANDOM()").first
  )
end



puts "✅ Done seeding!"
