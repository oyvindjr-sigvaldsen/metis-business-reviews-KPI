require_relative "../requirements"
require_relative "../global-modules/retrieve_sql_credentials"

require_relative "../global-classes/business_info"
require_relative "../global-modules/retrieve_html_file_paths"

def business_info_scraper(html_files)

	# TODO: create class for business, review_user
	begin
		business_info_instances = []

		html_files.each do |html_file|

			# TODO: make use open-uri or net/http to open live webpage using URL
			parsed_page = Nokogiri::HTML(open(html_file))

			begin

				name = parsed_page.css("h1").text
				num_reviews = parsed_page.css("a.restaurants-detail-overview-cards-RatingsOverviewCard__ratingCount--DFxkG").text
				price_point = parsed_page.xpath("//*[@id='taplc_resp_rr_top_info_rr_resp_0']/div/div[3]/div[3]/div/a[1]").text

				cuisines = []
				raw_cuisines = parsed_page.css("div.header_links").css("a").to_a.drop(1)
				puts raw_cuisines.length

				#business_info_instance = BusinessInfo.new(name, number_of_reviews, price_point, )
				#business_info_instances.push(business_info_instance)

			rescue
				next
			end
		end
		return business_info_instances

	# catch 'no such file'
	rescue Errno::ENOENT => error
		puts error
	end
end

def push_business_info_sql(business_info_instances)

	# https://docs.microsoft.com/en-us/azure/mysql/connect-ruby
	username, password = retrieve_sql_credentials("../mysql_credentials.json")
	connection = Mysql2::Client.new(:host => "localhost", :username => username, :database => "metis_development", :password => password)

	connection.query("DELETE FROM business_info")

	business_info_instances.each do |instance|

		begin
			connection = Mysql2::Client.new(:host => "localhost", :username => username, :database => "metis_development", :password => password)
			connection.query("INSERT INTO business_info VALUES(
																'#{instance.instance_variable_get(:@name)}',
																'#{instance.instance_variable_get(:@number_of_reviews)}',
																'#{instance.instance_variable_get(:@price_point)}',
																'#{instance.instance_variable_get(:@cuisines)}',
																'#{instance.instance_variable_get(:@star_rating)}'
															)")
			connection.close

		# catch Mysql2 syntax and other errors
		rescue Mysql2::Error => error
			puts error
		end
	end
end

html_files = retrieve_html_file_paths("retrieve-html-files/data-files/business_urls.json")
puts html_files
business_info_instances = business_info_scraper(html_files)
#push_business_info_sql(business_info_instances)
