require_relative '../config/environment'
require_relative './helpermethods'
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
    else
        # create user
        username = prompt.ask("Enter a username: ")
        pw = prompt.mask("Enter password: ")
        user = User.create({name: username, password: pw})
        logged_in = true
        puts "Welcome, #{user.name}! Thanks for signing up!"
    end
end

exit = false
until exit 

    pause
    action = prompt.select("What would you like to do?",
        ["See My Reviews","Create Review","Change or Delete Review","Explore Spots","Exit"])

    case action 

    when "See My Reviews"
        puts "My Reviews:"
        user.reload.reviews.each do |r|
            puts '-------------'
            spot = Bar.all.find { |b| b.id == r.bar_id }
            puts "#{spot.business_name.nil? ? (spot.name) : (spot.business_name)} | #{spot.contact_number}"
            puts "Rating: #{r.rating}"
        end

    when "Create Review"
        spot_name = prompt.ask("What Spot would you like to Review?")
        spot = Bar.all.find { |b| b.business_name == spot_name || b.name == spot_name }
            if spot
                puts "#{spot.name}"
                rate = prompt.ask("Please rate #{spot_name} from 0-10")
                new_review = Review.create({user_id: user.id,bar_id: spot.id,rating: rate})
                puts "Review created!"
            else 
                puts "Spot not found"
            end

    when "Change or Delete Review"
        choices = user.reload.reviews.map do |r|
            spot = Bar.all.find { |b| b.id == r.bar_id }
            "#{spot.business_name.nil? ? (spot.name) : (spot.business_name)}: #{r.rating}"
        end
        my_review = prompt.enum_select("Choose a Review to Edit/Delete:",choices)
        ind = choices.find_index(my_review)
        review_to_change = user.reviews[ind]
        crud = prompt.select("Would you like to Edit or Delete this Review?",["Edit","Delete"])
        
        case crud

        when 'Edit'
            new_rating = prompt.ask("What is your new Rating for this Spot?")
            review_to_change.rating = new_rating
            review_to_change.save
            sleep(0.25)
            puts "Review Updated!"
            
        when 'Delete'
            x = prompt.yes?("Are you sure you want to delete this Review?")
            if x
                review_to_change.reload.delete
                sleep(0.25)
                puts "Review Deleted! (ノಠ益ಠ)ノ彡┻━┻"
            end
        end

    when "Explore Spots"
        att = prompt.select('',['By Name','By City','By Zip'])
        case att
        when 'By Zip'
            spot = search_spots_by("zip")
        when 'By City'
            spot = search_spots_by("city")
        
        when 'By Name'
            spot = search_spots_by("name")
        end
        
    when "Exit"
        exit = true
    end

end
