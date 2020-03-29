require_relative "../requirements"
require_relative "../global-classes/review"

require_relative "../global-modules/sql/push/push_reviews_sql"
require_relative "../global-modules/sql/create_connection_sql"
require_relative "../global-modules/sql/clear_table_sql"

require_relative "../global-modules/retrieve_file_paths"

# modules/

	# zomato_reviews.rb
require_relative "modules/zomato_reviews"
json_file_paths = retrieve_file_paths("../data-files/business_data_tokens.json", ".json")
reviews_parser(json_file_paths)

	# zomato_business_info.rb
#require_relative "modules/zomato_business_info.rb"
