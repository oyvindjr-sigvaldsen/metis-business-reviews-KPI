class BusinessInfo

	def initialize(name, number_of_reviews, price_point, cuisines, star_rating)
		@name = name
		@number_of_reviews = number_of_reviews
		@price_point = price_point
		@cuisines = cuisines
		@star_rating = star_rating
	end

	def display
		puts "\n**#{@name}**\n#{@number_of_reviews}\n#{@price_point}\n#{@cuisines}\n#{@star_rating}\n"
	end

	def hash
		[@name, @number_of_reviews, @price_point, @cuisines, @star_rating]
	end
end
