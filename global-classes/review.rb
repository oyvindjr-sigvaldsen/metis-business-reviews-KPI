class Review

	def initialize(star_rating, date, check_in, photos, text)
		@star_rating = star_rating
		@date = date
		@check_in = check_in
		@photos = photos
		@text = text
	end

	def display
		puts "\n**#{@star_rating}**\n#{@date}\n#{@check_in}\n#{@photos}\n#{@text}\n"
	end
end
