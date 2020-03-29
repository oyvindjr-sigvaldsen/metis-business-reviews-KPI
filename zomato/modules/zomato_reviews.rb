def reviews_parser(json_file_paths)

	#clear_table_sql("zomato_reviews")

	json_file_paths.each do |json_file_path|

		begin
			json_file = File.read json_file_path
			reviews_json_data = JSON.parse(json_file, symbolize_keys: true)

			reviews_json_data["reviews"].each do |review|

				# business_name
				business_name = json_file_path[21...].to_s.chomp(".json")

				# title
				title = review["review"]["rating_text"].to_s

				if title =="Not rated"
					title = nil
				end

				# review_date
				raw_review_date = review["review"]["review_time_friendly"]

				review_date = Date.parse(review["review"]["review_time_friendly"]).to_s

				# star_rating
				star_rating = review["review"]["rating"].to_s

				if star_rating == "0"
					star_rating = nil
				end

				# text
				text = review["review"]["review_text"].split.join(" ").gsub(/([a-z])((?:[^.?!]|\.(?=[a-z]))*)/i) { $1.upcase + $2.rstrip }.tr("''", "").to_s.gsub(/[^[:alnum:][:blank:][:punct:]]/, '').squeeze(' ').strip

				# username
				username = review["review"]["user"]["name"].to_s.gsub(/[^[:alnum:][:blank:][:punct:]]/, '').squeeze(' ').strip

				# number_of_reviews
				number_of_reviews = review["review"]["user"]["no_of_reviews"].to_i

				# push review class instance to sql
				review_instance = Review.new(business_name, title, nil, review_date, star_rating, text, nil, username, number_of_reviews)
				push_reviews_sql(review_instance, "zomato_reviews", 250)
			end

		# catch 'no such file'
		rescue Errno::ENOENT => error
			puts error
			next
		end
	end
end
