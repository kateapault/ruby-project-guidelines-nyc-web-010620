require_relative '../config/environment'
require_relative './helpermethods'
prompt = TTY::Prompt.new

def pause()
    puts "\npress enter to continue"
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

logged_in = false
puts logo
until logged_in
    start_action = prompt.select('',['Log In','Sign Up','About'])
    
    case start_action
    
    when "Log In"
        username = prompt.ask("Enter Username: ")
        user = User.all.find { |u| u.name == username }
        if user
            pw = prompt.mask("Enter Password: ")
            if user.password == pw
                logged_in = true
                puts "Welcome, #{user.name}!"
            else 
                puts "Wrong password! Please try again."
            end
        else
            puts "Username not found. Please sign up."
        end
    
    when "Sign Up"
        unique_username = false
        until unique_username 
            username = prompt.ask("Enter a username: ")
            if User.all.find { |u| u.name == username }
                puts "Sorry, that username is taken. Please try again."
            else
                unique_username = true
            end
        end
        pw = prompt.mask("Create password: ")
        user = User.create({name: username, password: pw})
        logged_in = true
        puts "Welcome, #{user.name}! Thanks for signing up!"
    
    when "About"
        puts "This super cool program was made by Ed and Kate for their mod 1 project.\n They used the Soda API gem and their brillaint brains to make this."
    end
end

exit = false
until exit 

    pause
    action = prompt.select("What would you like to do?",
        ["See My Reviews","Create Review","Explore Spots","See Another Person's Reviews","Exit"])

    case action 

    when "See My Reviews"
        puts "My Reviews:"
        my_reviews = user.reload.reviews
        if my_reviews.size > 0
            selected_review = selectable_reviews(my_reviews)
            this_spot = Bar.all.find { |b| b.id == selected_review.bar_id }
            this_spot.business_name.nil? ? (name = this_spot.name) : (name = this_spot.business_name)
            puts "#{name} | #{this_spot.contact_number}\nRating: #{selected_review.rating}\n#{selected_review.comments}"
            review_action = prompt.select('',['Edit','Delete','Back'])
            case review_action
            when 'Edit'
                edit_review(selected_review)
            when 'Delete'
                delete_review(selected_review)
            end
        else
            puts "No reviews yet!"
        end

    when "Create Review"
        spot_name = prompt.ask("What Spot would you like to Review?").upcase!
        spot = Bar.all.find { |b| b.business_name == spot_name || b.name == spot_name }
            if spot
                if reviewed_spot = spot.reviews.find { |d| d.user_id == user.id }
                   y = prompt.yes?("Would you like to edit your Review?")
                    if y 
                        new_rating = prompt.ask("What is your new Rating for this Spot?")
                        reviewed_spot.rating = new_rating
                        new_comment = prompt.ask("Update your Comment on this Spot")
                        reviewed_spot.comments = new_comment
                        reviewed_spot.save
                        sleep(0.25)
                        puts "Review Updated!"
                    end
                else
                    puts "#{spot.name}"
                    rate = prompt.ask("Please rate #{spot_name} from 0-10: ")
                    comment = prompt.ask("Please enter your comments on this Spot: ")
                    new_review = Review.create({user_id: user.id,bar_id: spot.id,rating: rate,comments: comment})
                    puts "Review created!"
                end
            else 
                puts "Spot not found"
            end
    when "Explore Spots"
        att = prompt.select('',['By Name','By City','By Zip','Back'])
        case att
        when 'By Zip'
            spot = search_spots_by("zip")
            spot_profile(spot)
        when 'By City'
            spot = search_spots_by("city")
            spot_profile(spot)
        when 'By Name'
            spot = search_spots_by("name")
            spot_profile(spot)
        end
        
    when "See Another Person's Reviews"
        users = User.all
        chosen_user = prompt.select("Select user:") do |menu|
            users.each do |u|
                menu.choice "#{u.name}", u
            end
        end
        chosen_reviews = chosen_user.reviews
        puts "#{chosen_user.name} : #{chosen_reviews.size} reviews\n----------------"
        if chosen_reviews.size > 0
            chosen_reviews.each do |r|
                this_spot = Bar.all.find { |b| b.id == r.bar_id }
                this_spot.business_name.nil? ? (name = this_spot.name) : (name = this_spot.business_name)
                puts "#{name} | #{this_spot.contact_number}\nRating: #{r.rating}\n#{r.comments}\n---"    
            end
        else
            puts "No reviews yet!"
        end
    when "Exit"
        exit = true
    end

end
