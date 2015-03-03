# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

anime = Category.create(name: "Anime")
Category.create(name: "Movie")

Video.create(title: "Attack On Titan", description: "The top 1 anime in 2013", small_cover_url: "/tmp/attack_on_titan.jpg", large_cover_url: "/tmp/attack_on_titan_large.jpg", category: anime)
Video.create(title: "Grande Road", description: "A passionate anime", small_cover_url: "/tmp/grande_road.jpg", category: anime)
Video.create(title: "Tokyo Ghoul", description: "Amazing...", small_cover_url: "/tmp/tokyo_ghoul.jpg", category: anime)
Video.create(title: "Kiseji", description: "The best anime in 2014", small_cover_url: "/tmp/kiseji.jpg", category: anime)
