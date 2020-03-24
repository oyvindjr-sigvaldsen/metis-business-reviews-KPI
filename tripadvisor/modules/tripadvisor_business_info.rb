require_relative "../../requirements"
require_relative "../../global-classes/business_info"

require_relative "../../global-modules/retrieve_sql_credentials"
require_relative "../../global-modules/push_business_info_sql"
require_relative "../../global-modules/retrieve_html_file_paths"

def business_info_scraper(html_files)

	begin
		business_info_instances = []

		html_files.each do |html_file|

			parsed_page = Nokogiri::HTML(open(html_file))

			name = parsed_page.css("h1").text[/[^,]+/].tr("''", "")
			number_of_reviews = parsed_page.css("div.ratingContainer").css("a").text.chomp("reviews").to_i
			price_point = parsed_page.xpath("//*[@id='taplc_resp_rr_top_info_rr_resp_0']/div/div[3]/div[3]/div/a[1]").text
			star_rating = parsed_page.css("span.restaurants-detail-overview-cards-RatingsOverviewCard__overallRating--nohTl").text.to_f

			cuisines = []
			raw_cuisines = parsed_page.css("div.header_links").css("a").to_a.drop(1)

			(0..raw_cuisines.length).step(1) do |i|
				begin
					cuisine = raw_cuisines[i].text.to_s
					cuisines.push(cuisine)
				rescue
					next
				end
			end

			business_info_instance = BusinessInfo.new(name, number_of_reviews, price_point, cuisines, star_rating)
			business_info_instances.push(business_info_instance)
		end
		return business_info_instances

	# catch 'no such file'
	rescue Errno::ENOENT => error
		puts error
	end
end

html_files = retrieve_html_file_paths("retrieve-html-files/data-files/business_urls.json")
business_info_instances = business_info_scraper(html_files)
push_business_info_sql(business_info_instances, "tripadvisor_business_info")
