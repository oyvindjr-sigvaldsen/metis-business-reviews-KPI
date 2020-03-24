class BusinessInfo

	def initialize(name, number_of_reviews, price_point, cuisines, star_rating)
		#@name = name.to_s.tr("'", "")
		#@number_of_reviews = number_of_reviews.chomp("reviews").to_i
		#@price_point = price_point.to_s.chomp(" ")
		#@cuisines = cuisines.to_s.tr(" ", "").split(",").to_a
		#@star_rating = star_rating.to_s.chomp("star rating")

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
		[@name.to_s, @number_of_reviews.chomp("reviews").to_i, @price_point.to_s.chomp(" "), @cuisines.to_s.split(","), @star_rating.to_s.chomp("star rating")]
	end
end
