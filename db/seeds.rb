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
	for user in users
		title = Faker::Name.name
		content = "";
		5.times do
			content += Faker::Lorem.paragraph(2) + "  ";
		end
		user.articles.create!(content: content, title: title, draft: false)
	end
end
