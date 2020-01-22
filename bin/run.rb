require_relative '../config/environment'

prompt = TTY::Prompt.new

def pause()
    gets
    system('clear')
end

logo = '
 .d8888b.  8888888b.   .d88888b. 88888888888 88888888888 8888888888 8888888b.  
d88P  Y88b 888   Y88b d88P" "Y88b    888         888     888        888   Y88b 
Y88b.      888    888 888     888    888         888     888        888    888 
 "Y888b.   888   d88P 888     888    888         888     8888888    888   d88P 
    "Y88b. 8888888P"  888     888    888         888     888        8888888P"  
      "888 888        888     888    888         888     888        888 T88b   
Y88b  d88P 888        Y88b. .d88P    888         888     888        888  T88b  
 "Y8888P"  888         "Y88888P"     888         888     8888888888 888   T88b 
                                                                             
                                                                              
'

puts logo
logged_in = false
until logged_in
    start_action = prompt.select('',['Log in','Sign up'])
    if start_action == 'Log in'
        username = prompt.ask("Enter a username: ")
        user = User.all.find { |u| u.name == username }
        if user
            pw = prompt.mask("Enter password: ")
            if user.password == pw
                logged_in = true
                puts "Welcome, #{user.name}!"
            else 
                puts "Wrong password! Please try again."
            end
        else
            puts "No such user found. Please sign up."
        end
    else
        # create user
        username = prompt.ask("Enter a username: ")
        pw = prompt.mask("Enter password: ")
        user = User.create({name: username, password: pw})
        logged_in = true
    end
end

exit = false
until exit 
    pause
    action = prompt.select("What would you like to do?",["See my reviews","Search for a spot","Create review","Explore spots","Exit"])

    case action 
    when "See my reviews"
        puts "My Reviews:"
        user.reviews.each do |r|
            puts '-------------'
            spot = Bar.all.find { |b| b.id == r.bar_id }
            puts "#{spot.business_name}"
            puts "Your rating: #{r.rating}"
        end
    when "Search for a spot"
        spot_name = prompt.ask("Enter the name of the spot you want to search: ")
        sleep(1)
        puts "la la la searching for #{spot_name}"
        sleep(1)
        spot = Bar.all.find { |b| b.name == spot_name }
        if spot
            puts spot.name
            puts "Average rating: still a mystery"
            puts "Reviews: "
            spot.reviews.each do |review|
                puts review
            end
        else
            puts "No spot with that name found."
        end
    when "Create review"
        spot_name = prompt.ask("What spot would you like to add a review for?")
        spot = Bar.all.find { |b| b.business_name == spot_name }
        rate = prompt.ask("How would you rate #{spot_name}?")
        binding.pry
        puts "spot: #{spot}"
        new_review = Review.create({user_id: user.id,bar_id: spot.id,rating: rate})
        puts "Review created!"
    when "Explore spots"
        att = prompt.select('',['By zip code','By city','Random'])
        case att
        when 'By zip code'
            zip = prompt.ask("Enter zip code: ")
            zip_bars = Bar.all.select { |b| b.address_zip == zip }
            if zip_bars.size == 0
                puts "Sorry, no spots found there!"
            else
                zip_bars.each do |b| 
                    if b.business_name
                        puts b.business_name 
                    else
                        puts b.name
                    end
                end
            end
        when 'By city'
            city = prompt.ask("Enter city: ")
            city_bars = Bar.all.select { |b| b.address_city == city }
            if !city_bars
                puts "Sorry, no spots found there!"
            else
                city_bars.each do |b| 
                    if b.business_name
                        puts b.business_name 
                    else
                        puts b.name
                    end
                end
            end
        when 'Random'
            Bar.all[0..5]
        end
    when "Exit"
        exit = true
    end

end

# create review
def create_review(user)


end

# create new bar/restaurant/place


# user login stuff


# start_action = prompt.select(' ',['Sign up','Log in'])
# if start_action == 'Sign up'
#     # create user
# else
#     # log in user
# end

# # create user method
# def create_user

# end
# # log in method

# see all reviews for logged in user (self)




# edit review
    # can only edit own reviews
#delete review
    # can only delete own reviews

# add new bar method