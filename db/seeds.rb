# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

5.times do
  user = User.create({name: Faker::Name.name})
end

# user with sleep history
unless User.last.blank?
  User.last(3).each do |user|
    5.times do
      user.sleep_times.create(started_at: Time.current,
                              ended_at: Time.current,
                              sleep_duration_in_seconds: rand(1000))
    end
  end
end