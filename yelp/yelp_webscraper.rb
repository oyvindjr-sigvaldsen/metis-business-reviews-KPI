begin
	require_relative "../requirements"
	require_relative "../global-classes/review"

	require_relative "../global-modules/sql/push_review_sql"
	require_relative "../global-modules/sql/create_connection_sql"

	require_relative "../global-modules/retrieve_file_paths"
	require_relative "../global-modules/retrieve_business_data_token"

	# modules/

		# yelp_reviews.rb
	require_relative "modules/yelp_reviews"
	html_file_paths = retrieve_file_paths("../data-files/business_data_tokens.json", ".html")
	reviews_scraper(html_file_paths)

rescue LoadError => error
	puts error
end
