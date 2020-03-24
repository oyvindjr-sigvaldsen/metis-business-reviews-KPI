require_relative "../../requirements"
require_relative "../../global-classes/review"

require_relative "../../global-modules/retrieve_sql_credentials"
require_relative "../../global-modules/retrieve_html_file_paths"

def reviews_scraper(html_files)

	# TODO: finish reviews_scraper.rb
	nil
end

html_files = retrieve_html_file_paths("retrieve-html-files/data-files/business_urls.json")
reviews_scraper(html_files)
