require_relative "../requirements"
require_relative "classes/business_info"

def yelp_scraper(test_cases)

	# business info xpath array
	business_info_xpaths = [
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/div[1]/h1", # name
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/div[2]/div[2]/p", # num reviews
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/span[1]/span", # price point
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/span[2]", # cuisine(s)
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/div[2]/div[1]/span/div", # star rating
						]

	# TODO: create class for business, review, review_user
	begin

		test_cases.each do |test_case|

			# TODO: make use open-uri or net/http to open live webpage using URL
			parsed_page = Nokogiri::HTML(open(test_case))
			business_info = []

			business_info_xpaths.each_with_index do |xpath, i|

				# add index exceptions (int)
				if i != 4
					info = parsed_page.xpath(xpath).method(:text)
					business_info.push(info.call.to_s)
				else
					info = parsed_page.xpath(xpath).attribute("arial-label")
					business_info.push(info)
				end
			end

			business_info_instance = BusinessInfo.new(*business_info)
			business_info_instance.display
		end

	# catch 'no such file'
	rescue Errno::ENOENT => error
		puts error
	end
end

def retrieve_sql_credentials(credentials_path)

	credentials_file = open(credentials_path)
	json = credentials_file.read
	parsed_json = JSON.parse(json)

	return parsed_json["username"], parsed_json["password"]
end

# using hardcoded biz paths and .html files for testing purposes
test_cases = [
				"test-cases/little_nepal.html",
				"test-cases/blue_plate.html"
			]

yelp_scraper(test_cases)

retrieve_sql_credentials("../mysql_credentials.json")


#@db_host  = "localhost"
#@db_user  =
#@db_pass  =
#@db_name = "metis_development"
