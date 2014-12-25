User.create!(
	name: "Example user",
	email: "example@example.org",
	password: "foobar",
	password_confirmation: "foobar"
)

#create users
99.times do |n|
	name = Faker::Name.name
	email = "example-#{n+1}@example.org"
	password = "password"
	User.create!(
		name: name,
		email: email,
		password: password
	)
end

#create posts
users = User.order(:created_at).take(6)
50.times do
	title = Faker::Name.name
	content = Faker::Lorem.paragraph(2)
	users.each { |user| user.articles.create!(content: content, title: title) }
end
