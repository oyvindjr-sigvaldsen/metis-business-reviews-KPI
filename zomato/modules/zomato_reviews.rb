require_relative "../../requirements"
require_relative "../../global-classes/review"

require_relative "../../global-modules/sql/retrieve_sql_credentials"
require_relative "../../global-modules/sql/push_reviews_sql"

require_relative "../../global-modules/retrieve_file_paths"

def reviews_parser(json_file_paths)

	review_instances = []

	json_file_paths.each do |json_file_path|

		begin

			json_file = File.read json_file_path
			reviews_json_data = JSON.parse(json_file, symbolize_keys: true)

			reviews_json_data["reviews"].each do |review|

				# business_name
				business_name =  json_file_path[21...].to_s.chomp(".json")

				# title
				title = review["review"]["rating_text"].to_s

				if title =="Not rated"
					title = nil
				end

				# visit_date
				visit_date = nil

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

				# photos
				photos = nil

				# username
				username = review["review"]["user"]["name"].to_s.gsub(/[^[:alnum:][:blank:][:punct:]]/, '').squeeze(' ').strip

				# number_of_reviews
				number_of_reviews = review["review"]["user"]["no_of_reviews"].to_i

				# Review instance
				review_instance = Review.new(business_name, title, visit_date, review_date, star_rating, text, photos, username, number_of_reviews)
				review_instances.push(review_instance)
			end

		# catch 'no such file'
		rescue Errno::ENOENT => error
			puts error
			next
		end
	end
	return review_instances
end

json_file_paths = retrieve_file_paths("retrieve-files/data-files/business_ids.json", "business_ids", ".json")
review_instances = reviews_parser(json_file_paths)
push_reviews_sql(review_instances, "zomato_reviews")
