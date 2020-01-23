require 'soda/client'

Bar.destroy_all
User.destroy_all
Review.destroy_all

def call_results
    client = SODA::Client.new({:domain => "data.cityofnewyork.us", :app_token => "ZT1h204ngahoXzGHQC8ebl5lo"})
    results = client.get("https://data.cityofnewyork.us/resource/w7w3-xahh.json", {"$limit" => 5000,"$where" => "industry = 'Sidewalk Cafe'"})
    results_api = results.body
        puts "Got #{results_api.size} results."
    results_api.each do |result| 
    Bar.create({name:result["business_name"], business_name:result["business_name_2"], address_city:result["address_city"], address_zip:result["address_zip"], contact_number:result["contact_phone"]})
    end
end
call_results

User.create({name: "u",password:"j"})

# user1 = User.create({name:"Aly"})
# user2 = User.create({name:"Bob"})
# user3 = User.create({name:"John"})
# user4 = User.create({name:"Sue"})

# bar1 = 
# bar2 =
# bar3 = 
# bar4 = 

# rev1 = Review.create({user_id: user1.id,bar_id: bar2.id,rating: 5})
# rev2 = Review.create({user_id: user2.id,bar_id: bar3.id,rating: 3})
# rev3 = Review.create({user_id: user3.id,bar_id: bar4.id,rating: 2})
# rev4 = Review.create({user_id: user4.id,bar_id: bar1.id,rating: 4})
# rev5 = Review.create({user_id: user1.id,bar_id: bar1.id,rating: 3})
# rev6 = Review.create({user_id: user2.id,bar_id: bar2.id,rating: 4})
# rev7 = Review.create({user_id: user3.id,bar_id: bar3.id,rating: 2})
# rev8 = Review.create({user_id: user4.id,bar_id: bar4.id,rating: 3})

