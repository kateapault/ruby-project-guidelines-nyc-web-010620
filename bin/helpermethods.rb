require_relative '../config/environment'

def edit_review(review)
    prompt = TTY::Prompt.new
    new_rating = prompt.ask("What is your new Rating for this Spot?").to_i.clamp(0,10)
    review.rating = new_rating
    new_comment = prompt.ask("Update your Comment on this Spot")
    review.comments = new_comment
    review.save
    sleep(0.25)
    puts "Review Updated!"
end


def delete_review(review)
    prompt = TTY::Prompt.new
    x = prompt.yes?("Are you sure you want to delete this Review?")
    if x
        review.reload.delete
        sleep(0.25)
        puts "Review Deleted! (ノಠ益ಠ)ノ彡┻━┻"
    end
end


def selectable_reviews(arr)
    prompt = TTY::Prompt.new
    #takes in array of reviews, makes them selectable options

    prompt.select('') do |menu|
        arr.each do |rev|
            spot = Bar.all.find { |b| b.id == rev.bar_id }
            spot.business_name.nil? ? (name = spot.name) : (name = spot.business_name)
            review_info = "#{name} | #{spot.contact_number}\nRating: #{rev.rating}\n#{rev.comments}"
            review_info = review_info + "\n-------------"
            menu.choice "#{review_info}", rev
        end
    end
end


def selectable_spots(arr)
    prompt = TTY::Prompt.new
    # takes in array of businesses, makes them selectable options
    prompt.select('') do |menu|
        arr.each do |spot|
            spot["business_name"] ? (name = spot["business_name"]) : (name = spot["name"])
            rates = spot.reviews.map { |r| r.rating }
            if rates.size > 0
                rates_info = "Average rating: #{rates.sum/rates.size}"
            else
                rates_info = "No reviews yet"
            end    
            rates_info = rates_info + "\n---------------------------------"
            menu.choice "#{name}| #{spot.address_city} | #{spot.contact_number}\n#{rates_info}", spot
        end
    end
end

def spot_profile(arg,logged_in_user)
    prompt = TTY::Prompt.new
    puts "#{arg.business_name.nil? ? (arg.name) : (arg.business_name)} | #{arg.address_city} | #{arg.contact_number}"
    puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    arg.reviews.each do |review|
        user = User.all.find {|u| u.id == review.user_id}
        puts "#{user.name} gave this place a #{review.rating}\n #{review.comments}"
        puts "---------------------------------"
    end
        if review = arg.reviews.find { |d| d.user_id == logged_in_user.id }
            y = prompt.yes?("Would you like to edit your Review?")
             if y 
                 new_rating = prompt.ask("What is your new Rating for this Spot?")
                 review.rating = new_rating
                 new_comment = prompt.ask("Update your Comment on this Spot")
                 review.comments = new_comment
                 review.save
                 sleep(0.25)
                 puts "Review Updated!"
             end
         else
            x = prompt.yes?("Would you like leave a Review for #{arg.name}?")
                if x 
                    rate = prompt.ask("Please rate #{arg.name} from 0-10: ")
                    comment = prompt.ask("Please enter your comments on this Spot: ")
                    new_review = Review.create({user_id: logged_in_user.id,bar_id: arg.id,rating: rate,comments: comment})
                    puts "Review created!"
                end
         end
    end

def search_spots_by(attribute)
    prompt = TTY::Prompt.new
    search_term = nil
    until search_term
        system('clear')
        search_term = prompt.ask("Enter #{attribute} to search: ")
    end
    if attribute != "zip"
    search_term.upcase!
    end
    spots = Bar.all.select do |spot|
        case attribute
        when "city"
            spot.address_city == search_term
        when "zip"
            spot.address_zip == search_term
        when "name"
            if spot["business_name"]
                spot["business_name"].include?(search_term)
            elsif spot["name"]
                spot["name"].include?(search_term)
            end
        end
    end

    if spots.size > 0
        selectable_spots(spots)
    else
        puts "Sorry, didn't find any spots with that #{attribute}!"
    end
end