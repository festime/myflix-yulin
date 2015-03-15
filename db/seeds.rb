# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

anime = Category.create(name: "Anime")
Category.create(name: "Movie")

Video.create(title: "Attack On Titan", description: "Top 1 anime in 2013", small_cover_url: "/tmp/attack_on_titan.jpg", large_cover_url: "/tmp/attack_on_titan_large.jpg", category: anime)
Video.create(title: "Grande Road", description: "A passionate anime", small_cover_url: "/tmp/grande_road.jpg", category: anime)
Video.create(title: "Tokyo Ghoul", description: "Amazing...", small_cover_url: "/tmp/tokyo_ghoul.jpg", category: anime)
Video.create(title: "Kiseji", description: "Owesome!", small_cover_url: "/tmp/kiseji.jpg", category: anime)
Video.create(title: "Fate Zero", description: "Good", small_cover_url: "/tmp/fate_zero.jpg", large_cover_url: "/tmp/fate_zero_large.jpg", category: anime)
Video.create(title: "Hunter X Hunter", description: "Five stars", small_cover_url: "/tmp/hunter_hunter.jpg", category: anime)
Video.create(title: "Fullmetal Alchemist", description: "Not bad", small_cover_url: "/tmp/fullmetal_alchemist.jpg", large_cover_url: "/tmp/fullmetal_alchemist_large.jpg", category: anime)
Video.create(title: "Psycho Pass", description: "Amazing", small_cover_url: "/tmp/psycho_pass.jpg", large_cover_url: "/tmp/psycho_pass_large.jpg", category: anime)

yulin = User.create(name: "Yulin Chen",  email: "yulin@example.com", password: "password")
sofun = User.create(name: "Sofun Huang", email: "sofun@example.com", password: "password")

fate_zero   = Video.find_by(title: "Fate Zero")
tokyo_ghoul = Video.find_by(title: "Tokyo Ghoul")
Review.create(video: fate_zero, content: Faker::Lorem.paragraph, rate: (1..5).to_a.sample, user: yulin)
Review.create(video: tokyo_ghoul, content: Faker::Lorem.paragraph, rate: (1..5).to_a.sample, user: yulin)
Review.create(video: fate_zero, content: Faker::Lorem.paragraph, rate: (1..5).to_a.sample, user: sofun)
Review.create(video: tokyo_ghoul, content: Faker::Lorem.paragraph, rate: (1..5).to_a.sample, user: sofun)

QueueItem.create(video: fate_zero, user: yulin, position: 1)
QueueItem.create(video: tokyo_ghoul, user: yulin, position: 2)
QueueItem.create(video: fate_zero, user: sofun, position: 1)
QueueItem.create(video: tokyo_ghoul, user: sofun, position: 2)

