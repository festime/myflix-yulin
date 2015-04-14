# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

anime = Category.create(name: "Anime")
Category.create(name: "Movie")

videos_data = CSV.read Rails.root.join "lib/videos_information.csv"
headers = videos_data.shift.map {|header| header.to_sym}
array_of_hashes = videos_data.map {|video_data| Hash[*headers.zip(video_data).flatten] }

directory = "#{Rails.root}/public/tmp/"

array_of_hashes.each do |video_params|
  video_params[:small_cover] = File.open(directory + video_params[:small_cover])
  video_params[:large_cover] = File.open(directory + video_params[:large_cover]) if video_params[:large_cover]
  video_params[:category] = Category.find_by(name: video_params[:category])

  Video.create(video_params)
end

yulin = User.create(name: "Yulin Chen",  email: "yulin@example.com", password: "password", admin: true)
sofun = User.create(name: "Sofun Huang", email: "sofun@example.com", password: "password", admin: true)
winson = User.create(name: "Winson Lee", email: "winson@example.com", password: "password")
chris = User.create(name: "Chris Lee", email: "chris@example.com", password: "password")

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

Relationship.create(leader: yulin, follower: sofun)
Relationship.create(leader: yulin, follower: winson)
Relationship.create(leader: sofun, follower: yulin)
Relationship.create(leader: winson, follower: yulin)
Relationship.create(leader: chris, follower: yulin)

