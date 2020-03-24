begin
	require_relative "modules/business_info_scraper"
	require_relative "modules/reviews_scraper"

rescue LoadError => error
	puts error
end
