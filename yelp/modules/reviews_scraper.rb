require_relative "../requirements"
require_relative "../global-modules/retrieve_sql_credentials"

require_relative "classes/review"
require_relative "modules/retrieve_html_file_paths"

def reviews_scraper(html_files)

	# TODO: finish reviews_scraper.rb
	nil
end

html_files = retrieve_html_file_paths()
reviews_scraper(html_files)
