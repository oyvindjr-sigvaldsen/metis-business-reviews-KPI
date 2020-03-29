require_relative "../requirements"
require_relative "../global-classes/review"

require_relative "../global-modules/sql/push/push_reviews_sql"
require_relative "../global-modules/sql/create_connection_sql"
require_relative "../global-modules/sql/clear_table_sql"

require_relative "../global-modules/retrieve_file_paths"

# modules/

	# tripadvisor_reviews.rb
require_relative "modules/tripadvisor_reviews"
html_file_paths = retrieve_file_paths("../data-files/business_data_tokens.json", ".html")
reviews_scraper(html_file_paths)

#require_relative "modules/tripadvisor_business_info"
