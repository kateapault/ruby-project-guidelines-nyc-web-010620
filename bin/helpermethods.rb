require_relative '../config/environment'


def selectable_spots(arr)
    prompt = TTY::Prompt.new
    # takes in array of businesses, makes them selectable options
    prompt.select('') do |menu|
        arr.each do |spot|
            spot["business_name"] ? (name = spot["business_name"]) : (name = spot["name"])
            rates = spot.reviews.map { |r| r.rating }
            if rates.size > 0
                rates_info = "Average rating: #{rates.sum/rates.size}\nReviews:\n"
                spot.reviews.each do |review|
                    u = User.all.find { |user| user.id == review.user_id }
                    rates_info = rates_info + "\n#{u.name} gave this spot a #{review.rating}"
                end
            else
                rates_info = "No reviews yet"
            end    
            rates_info = rates_info + "\n---------------------------------"
            menu.choice "#{name}| #{spot.address_city} | #{spot.contact_number}\n#{rates_info}", spot
        end
    end
end

def search_spots_by(attribute)
    prompt = TTY::Prompt.new

    search_term = prompt.ask("Enter #{attribute} to search: ")
    spots = Bar.all.select do |spot|
        case attribute
        when "city"
            spot.address_city == search_term
        when "zip"
            spot.address_zip == search_term
        when "name"
            spot.business_name.nil? ? (spot.name == search_term) : (spot.business_name == search_term)
        end
    end

    if spots.size > 0
        selectable_spots(spots)
    else
        puts "Sorry, didn't find any spots with that #{attribute}!"
    end
end