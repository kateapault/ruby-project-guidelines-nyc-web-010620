# require 'database_cleaner'
# DatabaseCleaner.clean_with(:truncation)

user1 = User.create({name:"Aly"})
user2 = User.create({name:"Bob"})
user3 = User.create({name:"John"})
user4 = User.create({name:"Sue"})

bar1 = Bar.create({name: "Blarney Stone"})
bar2 = Bar.create({name: "Ron Blacks"})
bar3 = Bar.create({name: "Flamming Saddles"})
bar4 = Bar.create({name: "Bar Taco"})

rev1 = Review.create({user_id: user1.id,bar_id: bar2.id,rating: 5})
rev2 = Review.create({user_id: user2.id,bar_id: bar3.id,rating: 3})
rev3 = Review.create({user_id: user3.id,bar_id: bar4.id,rating: 2})
rev4 = Review.create({user_id: user4.id,bar_id: bar1.id,rating: 4})
rev5 = Review.create({user_id: user1.id,bar_id: bar1.id,rating: 3})
rev6 = Review.create({user_id: user2.id,bar_id: bar2.id,rating: 4})
rev7 = Review.create({user_id: user3.id,bar_id: bar3.id,rating: 2})
rev8 = Review.create({user_id: user4.id,bar_id: bar4.id,rating: 3})