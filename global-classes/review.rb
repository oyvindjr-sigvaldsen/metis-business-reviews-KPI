class Review

	def initialize(business_name, title, visit_date, review_date, star_rating, text, photos, username, number_of_reviews)
		@business_name = business_name
		@title = title
		@visit_date = visit_date
		@review_date = review_date
		@star_rating = star_rating
		@text = text
		@photos = photos
		@username = username
		@number_of_reviews = number_of_reviews
	end

	def display
		puts "\n____#{@business_name}____\n#{@title}\n#{@visit_date}\n#{@review_date}\n#{@star_rating}\n#{@text}\n#{@photos}\n#{@username}\n#{@number_of_reviews}"
	end
end
